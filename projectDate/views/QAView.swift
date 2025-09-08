//
//  QAView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 7/13/25.
//

import SwiftUI
import Combine
import Firebase

struct QAView: View {
    @State var timer: Cancellable?
    @State private var timeRemaining = 5
    @FocusState private var nameIsFocused: Bool
    @State private var currentUser: ProfileModel = emptyProfileModel
    @State private var updateQuestion: Bool = false
    @State private var showBlindChatTimerSheet: Bool = false
    @State private var currentQAWidgetState = QAWidgetState.inital
    @State private var showDeclineAlert: Bool = false
    
    @EnvironmentObject var delegate: AppDelegate
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var qaViewModel: QAViewModel
    @EnvironmentObject var videoViewModel: VideoViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    
    let geometry: GeometryProxy
    let timer2 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
            VStack {
                qaWidget(geometry: geometry)
            }
            .task {
                do {
                    /// get stuff for QAWidget
                    try await getCurrentUsers()
                    try await qaViewModel.getQuestions()
                    startProfileRotation()
                } catch {
                    //HANDLE ERROR
                }
            }
            /// display requestView once user recieves BlindChat request
            .onChange(of: delegate.requestByProfile) { oldValue, newValue in
                ///prevents video session from launching when routing to requestPage
                videoViewModel.roomCode = ""
                viewRouter.currentPage = .requestPage
                
            }
            /// once user accepts BlindChat request
            .onChange(of: delegate.isRequestAccepted) { oldValue, newValue in
                Task {
                    do {
                        if newValue == "true" {
                            
                            let videoConfig = VideoConfigModel (role: RoleType.host, isScreenBlurred: true, isFullScreen: true)
                            
                            self.showBlindChatTimerSheet = true
                            try await Task.sleep(for: .seconds(5))
                            
                            viewRouter.currentPage = .videoPage(videoConfig: videoConfig)
                        } else if newValue == "false" {
                            self.showDeclineAlert = true
                        }
                    } catch {
                        // HANDLE ERROR
                    }
                }
            }
            .alert("Sorry, user decline request", isPresented: $showDeclineAlert) {
                Button("OK", role: .cancel) { }
            }
            .sheet(isPresented: $showBlindChatTimerSheet) {
                blindChatCountdownSheet()
            }
            .onReceive(timer2) { time in
                if self.showBlindChatTimerSheet {
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    }
                    else {
                        self.showBlindChatTimerSheet = false
                    }
                }
            }
            /// makes sure questions stay in sync with currentUsers
            .onChange(of: self.currentUser) { oldValue, newValue in
                
                if oldValue.id != newValue.id {
                    self.updateQuestion.toggle()
                }
            }
        
    }
    
    private func qaWidget(geometry: GeometryProxy) -> some View {
        VStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.clear)
                .animation(.easeInOut, value: true)
                .overlay {
                    VStack {
                        switch currentQAWidgetState {
                        case .inital:
                            connectSection(geometry: geometry)
                            Spacer()
                                .frame(height: geometry.size.height * 0.06)
                            questionSection(geometry: geometry)
                        case .savingAnswer:
                            ProgressView {
                                
                            }
                            .scaleEffect(x: 2, y: 2, anchor: .center)
                            .padding(.bottom)
                            
                            Text("Saving Answer...")
                                .font(.system(size: 25))
                                .bold()
                                .foregroundColor(.yellow)
                        case .AnswerSaved:
                            Text("Answer Sent!")
                                .font(.system(size: 25))
                                .bold()
                                .foregroundColor(.green)
                        case .sendingBCRequest:
                            ProgressView {
                                
                            }
                            .scaleEffect(x: 2, y: 2, anchor: .center)
                            .padding(.bottom)
                            
                            Text("Sending Request...")
                                .font(.system(size: 25))
                                .bold()
                                .foregroundColor(.yellow)
                        case .BCRequestSent:
                            Text("Request Sent!")
                                .font(.system(size: 25))
                                .bold()
                                .foregroundColor(.green)
                        }
                    }
                }
        }
    }
    
    private func connectSection(geometry: GeometryProxy) -> some View {
        HStack{
            quickChatProfileSection(geometry: geometry)
            
            Spacer()
            
            Button(action:  {
                if let pickedUser = profileViewModel.currentUsers.first(where: {$0.id == self.currentUser.id}) {
                    Task {
                        currentQAWidgetState = .sendingBCRequest
                        
                        profileViewModel.participantProfile = pickedUser
                        try await sendRequestMessage(pickedUser: pickedUser)
                        
                        currentQAWidgetState = .BCRequestSent
                        
                        ///remove so user doesnt see again
                        profileViewModel.currentUsers.removeAll(where: {$0.id == self.currentUser.id})
                        
                        qaViewModel.questions.removeAll(where: {$0.id == qaViewModel.quickChatQuestion.id})
                        
                        ///display success view for 2 seconds
                        try await Task.sleep(for: .seconds(2))
                        currentQAWidgetState = .inital
                    }
                }
            }) {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(.green, lineWidth: 2)
                    .frame(width: 80, height: 40)
                    .overlay {
                        Text("BlindChat")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .bold()
                            .padding(5)
                    }
            }
            .disabled(!self.currentUser.isActive)
            .opacity(!self.currentUser.isActive ? 0.5 : 1)
        }
    }
    
    private func questionSection(geometry: GeometryProxy) -> some View {
        VStack{
            Text("\(qaViewModel.quickChatQuestion.body)")
                .bold()
                .font(.system(size: geometry.size.height * 0.025))
                .animation(.easeInOut)
                .foregroundColor(.white)
                .padding(.bottom, 2)
            
            HStack(spacing: 5) {
                TextField("Type in answer", text: $qaViewModel.answer.body)
                    .onSubmit {
                        startProfileRotation()
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        self.timer?.cancel()
                    })
                    .focused($nameIsFocused)
                    .foregroundColor(.gray)
                    .frame(width: geometry.size.width * 0.55, height: geometry.size.height * 0.02)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .textInputAutocapitalization(.never)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color.primaryColor, lineWidth: 1)
                    )
                
                Button(action:  {
                    Task {
                        currentQAWidgetState = .savingAnswer
                        try await qaViewModel.saveAnswer(profileId: profileViewModel.userProfile.id, askerProfileId: self.currentUser.id)
                        ///dismiss keyboard
                        nameIsFocused = false
                        
                        ///display success view for 2 seconds
                        currentQAWidgetState = .AnswerSaved
                        try await Task.sleep(for: .seconds(2))
                        currentQAWidgetState = .inital
                        
                        ///Clear if dirty
                        qaViewModel.answer.body = ""
                        
                        profileViewModel.currentUsers.removeAll(where: {$0.id == self.currentUser.id})
                        
                        qaViewModel.questions.removeAll(where: {$0.id == qaViewModel.quickChatQuestion.id})
                        
                        if qaViewModel.questions.count < 2 {
                           try await qaViewModel.getQuestions()
                        }
                        
                      //  startProfileRotation()
                    }
                }) {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color("tertiaryColor"), lineWidth: 2)
                        .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.055)
                        .overlay {
                            Text("Send")
                                .foregroundColor(.white)
                        }
                }
            }
        }
    }
    
    private func quickChatProfileSection(geometry: GeometryProxy) -> some View {
        HStack {
            Circle()
                .frame(width: geometry.size.width * 0.1)
                .overlay {
                    if !currentUser.profileImage.size.height.isZero {
                        Image(uiImage: currentUser.profileImage)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.black)
                            .clipShape(Circle())
                            .blur(radius: 6)
                            .frame(width: 50 , height: 50)
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: geometry.size.width * 0.05, height: geometry.size.height * 0.03)
                            .foregroundColor(.black)
                    }
                    
                }
                .foregroundColor(Color.secondaryColor)
            
            VStack{
                if !self.currentUser.name.isEmpty {
                    VStack(alignment: .leading) {
                        Text("\(self.currentUser.name)")
                            .bold()
                            .font(.title3)
                            .id(self.currentUser.id)
                            .transition(.opacity.animation(.smooth))
                            .foregroundColor(Color("tertiaryColor"))
                        
                        Text(self.currentUser.isActive ? "Active now": "")
                            .foregroundColor(Color("tertiaryColor"))
                            .font(.system(size: geometry.size.height * 0.015))
                    }
                } else {
                    Text("Searching for friends...")
                        .foregroundColor(Color("tertiaryColor"))
                }
            }
        }
    }
    
    private func changeColor () -> Color {
        switch currentQAWidgetState {
        case .inital:
            return .blue
        case .savingAnswer:
            return .yellow
        case .AnswerSaved:
            return .green
        case .sendingBCRequest:
            return .yellow
        case .BCRequestSent:
            return .green
        }
    }
    
    private func startProfileRotation() {
        guard !profileViewModel.currentUsers.isEmpty else { return }
        var index = 0
        
        self.currentUser = profileViewModel.currentUsers[0]
        self.timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect().sink { output in
            if !profileViewModel.currentUsers.isEmpty {
                index = (index + 1) % profileViewModel.currentUsers.count
                
                self.currentUser = profileViewModel.currentUsers[index]
                
                if self.updateQuestion {
                    qaViewModel.quickChatQuestion =  qaViewModel.questions.randomElement() ?? emptyQuestionModel
                    
                    self.updateQuestion.toggle()
                }
                
            } else {
                self.currentUser = emptyProfileModel
            }
        }
    }
    
    private func sendRequestMessage(pickedUser: ProfileModel) async throws {
        let fcmToken = try await profileViewModel.GetFCMToken(userId: pickedUser.userId)
        profileViewModel.userProfile.userId = Auth.auth().currentUser?.uid as Any as! String
        
        _ = try await profileViewModel.callSendRequestNotification(fcmToken: fcmToken, requestByProfile: profileViewModel.userProfile)
    }
    
    private func getCurrentUsers() async throws {
        try await profileViewModel.GetCurrentUsers()
    }
    
    private func blindChatCountdownSheet() -> some View {
        ZStack{
            Color.primaryColor
                .ignoresSafeArea()
            
            VStack{
                Text("\(self.timeRemaining)")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                
                Text("Until Chat starts")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
    }
}

#Preview {
    GeometryReader {
        geo in
        QAView(geometry: geo)
            .environmentObject(VideoViewModel())
            .environmentObject(AppDelegate())
            .environmentObject(QAViewModel())
            .environmentObject(ProfileViewModel())
    }
}

enum QAWidgetState {
    case inital, savingAnswer, AnswerSaved, sendingBCRequest, BCRequestSent
}
