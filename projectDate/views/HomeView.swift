//
//  HomeView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 2/18/25.
//

import SwiftUI
import Combine
import HMSRoomKit
import Firebase

struct HomeView: View {
    @EnvironmentObject var delegate: AppDelegate
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var qaViewModel: QAViewModel
    @EnvironmentObject var videoViewModel: VideoViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    @Binding var selectedTab: Int
    @FocusState private var nameIsFocused: Bool
    
    @State var timer: Cancellable?
    @State private var showingSheet = false
    @State private var videoConfig: VideoConfigModel = emptyVideoConfig
    @State private var currentUser: ProfileModel = emptyProfileModel
    @State private var isHeartSelected: Bool = false
    @State private var updateQuestion: Bool = false
    
    enum QAWidgetState {
        case inital, savingAnswer, AnswerSaved, sendingBCRequest, BCRequestSent
    }
    
    @State private var currentQAWidgetState = QAWidgetState.inital
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.primaryColor
                    .ignoresSafeArea()
                
                VStack{
                    header(geometry: geometry)
                    Spacer()
                        .frame(height: geometry.size.height * 0.02)
                    qaWidget(geometry: geometry)
                    Spacer()
                        .frame(height: geometry.size.height * 0.02)
                    videoSection(geometry: geometry)
                    events(geometry: geometry)
                    Spacer()
                }
            }
            .task {
                do {
                    /// get profile and launch video
                    try await profileViewModel.GetUserProfile()
                    try await profileViewModel.getFileFromStorage(profileId: profileViewModel.userProfile.id)
                    
                    videoViewModel.roomCode = profileViewModel.userProfile.roomCode
                    
                    /// update user app status to active
                    try await profileViewModel.UpdateActivityStatus(isActive: true)
                    
                    /// get stuff for QAWidget
                    try await getCurrentUsers()
                    try await qaViewModel.getQuestions()
                    startProfileRotation()
                    
                    /// check for newly answered questions
                    try await qaViewModel.getRecentQA(profileId: profileViewModel.userProfile.id)
                    
                } catch {
                    print("Error getting userProfile:\(error)")
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
                let videoConfig = VideoConfigModel (role: RoleType.host, isScreenBlurred: true, isFullScreen: true)
                viewRouter.currentPage = .videoPage(videoConfig: videoConfig)
            }
            .onChange(of: qaViewModel.recentQAs) { oldValue, newValue in
                if !newValue.isEmpty {
                    showingSheet = true
                }
            }
            /// makes sure questions stay in sync with currentUsers
            .onChange(of: self.currentUser) { oldValue, newValue in
                
                if oldValue.id != newValue.id {
                    self.updateQuestion.toggle()
                }
            }
            .sheet(isPresented: $showingSheet) {
                newAnswersSheet()
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private func header(geometry: GeometryProxy) -> some View {
        HStack{
            Circle()
                .frame(width: geometry.size.width * 0.08)
                .overlay {
                    if !profileViewModel.userProfile.profileImage.size.height.isZero {
                        Circle()
                            .overlay(
                                Image(uiImage: profileViewModel.userProfile.profileImage)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                            )
                            .frame(width: geometry.size.width * 0.09)
                        
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: geometry.size.width * 0.01, height: geometry.size.height * 0.01)
                    }
                    
                }
                .padding(.leading)
                .onTapGesture {
                    selectedTab = 2
                }
            
            Spacer()
            
            Text("LittleBigThings")
                .font(.custom("Copperplate", size: geometry.size.height * 0.03))
                .foregroundColor(Color("tertiaryColor"))
                .bold()
            
            Image("logo")
                .resizable()
                .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1)
            
            Spacer()
            
            Button(action : {
                viewRouter.currentPage = .notificationsPage
            }){
                Image(systemName: "bell.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * 0.07)
                    .foregroundColor(Color("tertiaryColor"))
                    .padding(.horizontal)
                    .clipShape(Circle())
            }
        }
    }
    
    private func qaWidget(geometry: GeometryProxy) -> some View {
        VStack{
            RoundedRectangle(cornerRadius: 20)
                .stroke(changeColor(), lineWidth: 2)
                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.25)
                .animation(.easeInOut, value: true)
                .overlay {
                    VStack {
                        switch currentQAWidgetState {
                        case .inital:
                            connectSection(geometry: geometry)
                            Spacer()
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
                            Text("Saved Answer!")
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
                    .padding(geometry.size.height * 0.02)
                }
        }
    }
    
    private func videoSection(geometry: GeometryProxy) -> some View {
        VStack {
            if !videoViewModel.roomCode.isEmpty {
                VideoView(videoConfig: videoConfig)
            }
            else {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.primaryColor)
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.4)
                    .overlay {
                        VStack {
                            ProgressView {
                                
                            }
                            .scaleEffect(x: 4, y: 4, anchor: .center)
                            .padding(.bottom)
                            
                            Text("Joining room...")
                                .font(.system(size: 25))
                                .bold()
                                .foregroundColor(.black)
                        }
                    }
            }
        }
    }
    
    private func events(geometry: GeometryProxy) -> some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    ForEach(0...4, id: \.self) {_ in
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.blue, lineWidth: 2)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.15)
                            .overlay{
                                HStack{
                                    HStack(spacing: -15) {
                                        ForEach(0...4, id: \.self) { _ in
                                            HStack(spacing: 0) {
                                                Circle()
                                                    .overlay {
                                                        Image(systemName: "person.fill")
                                                            .resizable()
                                                            .frame(width: geometry.size.width * 0.03, height: geometry.size.height * 0.02)
                                                            .foregroundColor(.black)
                                                    }
                                                    .foregroundColor(.gray)
                                                    .frame(width: geometry.size.width * 0.08, height: geometry.size.height * 0.08)
                                            }
                                        }
                                    }
                                    
                                    Text("Meet 1")
                                        .foregroundColor(Color("tertiaryColor"))
                                        .font(.system(size: geometry.size.height * 0.03))
                                        .bold()
                                        .padding(.bottom,5)
                                    
                                    HStack{
                                        Text("3/3/25 @4pm")
                                            .foregroundColor(Color("tertiaryColor"))
                                            .font(.system(size: geometry.size.height * 0.015))
                                    }
                                    .padding(.bottom)
                                }
                                .padding(5)
                                
                            }
                            .padding(5)
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0)
                                    .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                    .blur(radius: phase.isIdentity ? 0 : 10)
                            }
                        
                    }
                }
            }
        }
        .padding(.bottom)
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
                        try await Task.sleep(nanoseconds: 2_000_000_000)
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
                        try await Task.sleep(nanoseconds: 2_000_000_000)
                        currentQAWidgetState = .inital
                        
                        ///Clear if dirty
                        qaViewModel.answer.body = ""
                        
                        profileViewModel.currentUsers.removeAll(where: {$0.id == self.currentUser.id})
                        
                        qaViewModel.questions.removeAll(where: {$0.id == qaViewModel.quickChatQuestion.id})
                        
                        startProfileRotation()
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
                            .blur(radius: 2)
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
    
    private func newAnswersSheet() -> some View {
        ZStack{
            Color.primaryColor
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                Text("Congratulations!")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                
                
                Text("You got new answers from: ")
                    .foregroundColor(.white)
                    .font(.title)
                
                Spacer()
                
                newAnswersView()
                
                Spacer()
                
                Button(action: {
                    Task {
                        do {
                            try await qaViewModel.updateAnswers()
                            showingSheet.toggle()
                        } catch let error {
                            print("Error trying to deactive recent Answers: \(error)")
                        }
                    }
                    
                }) {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(.red, lineWidth: 2)
                        .frame(width: 340, height: 60)
                        .overlay {
                            Text("Dismiss")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .bold()
                                .padding(5)
                        }
                }
                Spacer()
            }
            
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
    
    private func getCurrentUsers() async throws {
        try await profileViewModel.GetCurrentUsers()
    }
    
    private func launchVideoSession(pickedUser: ProfileModel) async throws {
        // this removes HMSPreBuiltView and triggers its onDisappear()
        // makes sure current video sesh has closed
        videoViewModel.roomCode = ""
        
        // Delay of 5 seconds (1 second = 1_000_000_000 nanoseconds)
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        
        videoViewModel.roomCode = pickedUser.roomCode
        //viewRouter.currentPage = .videoPage
    }
    
    private func sendRequestMessage(pickedUser: ProfileModel) async throws {
        let fcmToken = try await profileViewModel.GetFCMToken(userId: pickedUser.userId)
        profileViewModel.userProfile.userId = Auth.auth().currentUser?.uid as Any as! String
        
        var response = try await profileViewModel.callSendRequestNotification(fcmToken: fcmToken, requestByProfile: profileViewModel.userProfile)
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
    
    private func newAnswersView() -> some View {
        ScrollView {
            ForEach(qaViewModel.recentQAs, id: \.self) { recentQA in
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(.white, lineWidth: 2)
                    .frame(width: 360, height: 80)
                    .overlay {
                        newAnswersBody(recentQA: recentQA)
                    }
                    .padding(5)
            }
        }
    }
    
    private func newAnswersBody(recentQA: QAModel) -> some View {
        HStack {
            VStack{
                Circle()
                    .overlay(
                        Image(uiImage: recentQA.profileImage)
                            .resizable()
                            .foregroundColor(.black)
                    )
                    .frame(width: 50)
                    .foregroundColor(.gray)
                
                Text("John Doe")
                    .foregroundColor(.white)
                    .font(.system(size: 10))
                    .bold()
            }
            
            Spacer()
            
            VStack{
                Text("\(recentQA.question.body)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .bold()
                
                Text("\(recentQA.answer.body)")
                    .foregroundColor(.green)
                    .font(.system(size: 10))
            }
            Spacer()
            Button(action: {
                self.isHeartSelected.toggle()
            }) {
                Image(systemName: "heart.circle")
                    .resizable()
                    .foregroundColor(self.isHeartSelected ? .red : .white)
                    .frame(width: 25, height: 25)
            }
        }
        .padding()
    }
}

#Preview {
    HomeView(selectedTab: .constant(0))
        .environmentObject(ProfileViewModel())
        .environmentObject(VideoViewModel())
        .environmentObject(AppDelegate())
        .environmentObject(EventViewModel())
        .environmentObject(QAViewModel())
}
