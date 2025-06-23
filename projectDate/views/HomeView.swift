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
    @State private var selectedButton: Int = 0
    @State private var videoConfig: VideoConfigModel = emptyVideoConfig
    @State private var currentActiveUser: ProfileModel = emptyProfileModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.primaryColor
                    .ignoresSafeArea()
                
                VStack{
                    header(geometry: geometry)
                    Spacer()
                        .frame(height: geometry.size.height * 0.02)
                    quickChat(geometry: geometry)
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
                    
                    /// for quickChat
                    try await getActiveUsers()
                    try await qaViewModel.getQuestions()
                    startProfileRotation()
                    
                } catch {
                    print("Error getting userProfile:\(error)")
                }
            }
            /// display requestView once user recieves request for BlindDate
            .onChange(of: delegate.requestByProfile) { oldValue, newValue in
                ///prevents video session from launching when routing to requestPage
                videoViewModel.roomCode = ""
                viewRouter.currentPage = .requestPage
                
            }
            /// once user accepts BlindDate request
            .onChange(of: delegate.isRequestAccepted) { oldValue, newValue in
                let videoConfig = VideoConfigModel (role: RoleType.host, isScreenBlurred: true, isFullScreen: true)
                viewRouter.currentPage = .videoPage(videoConfig: videoConfig)
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
    
    private func quickChat(geometry: GeometryProxy) -> some View {
        VStack{
            if selectedButton == 0 {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(changeColor(), lineWidth: 2)
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.25)
                    .opacity(selectedButton != 0 ? 0.5 : 1.0)
                    .animation(.easeInOut, value: true)
                    .overlay {
                        VStack {
                            connectSection(geometry: geometry)
                            Spacer()
                            questionSection(geometry: geometry)
                        }
                        .padding(geometry.size.height * 0.02)
                    }
            } else if selectedButton == 1 {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(changeColor(), lineWidth: 2)
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.25)
                    .opacity(selectedButton != 0 ? 0.5 : 1.0)
                    .animation(.easeInOut, value: true)
                    .overlay {
                        VStack {
                            Text("Saved Successfully")
                                .font(.largeTitle)
                                .foregroundColor(.green)
                        }
                        .padding(geometry.size.height * 0.02)
                    }
            }
            else if selectedButton == 2 {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(changeColor(), lineWidth: 2)
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.25)
                    .opacity(selectedButton != 0 ? 0.5 : 1.0)
                    .animation(.easeInOut, value: true)
                    .overlay {
                        VStack {
                            Text("Request Sent")
                                .font(.largeTitle)
                                .foregroundColor(.green)
                        }
                        .padding(geometry.size.height * 0.02)
                    }
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
                if let pickedUser = profileViewModel.activeUsers.first(where: {$0.id == self.currentActiveUser.id}) {
                    Task {
                        profileViewModel.participantProfile = pickedUser
                        try await sendRequestMessage(pickedUser: pickedUser)
                        
                        selectedButton = 2
                        ///display success view for 2 seconds
                        try await Task.sleep(nanoseconds: 2_000_000_000)
                        selectedButton = 0
                    }
                }
            }) {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(.green, lineWidth: 2)
                    .frame(width: 80, height: 40)
                    .overlay {
                        Text("Play")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .bold()
                            .padding(5)
                    }
            }
            .disabled(self.currentActiveUser.id.isEmpty)
            .opacity(self.currentActiveUser.id.isEmpty ? 0.5 : 1)
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
                        try await qaViewModel.saveAnswer(profileId: profileViewModel.userProfile.id)
                        ///dismiss keyboard
                        nameIsFocused = false
                        
                        ///display success view for 2 seconds
                        selectedButton = 1
                        try await Task.sleep(nanoseconds: 2_000_000_000)
                        selectedButton = 0

                        qaViewModel.answer.body = ""
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
                    if !currentActiveUser.profileImage.size.height.isZero {
                        Image(uiImage: currentActiveUser.profileImage)
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
                    if !self.currentActiveUser.name.isEmpty {
                        VStack(alignment: .leading) {
                            Text("\(self.currentActiveUser.name)")
                                .bold()
                                .font(.title3)
                                .id(self.currentActiveUser.id)
                                .transition(.opacity.animation(.smooth))
                                .foregroundColor(Color("tertiaryColor"))
                            
                            Text(self.currentActiveUser.id.isEmpty ? "": "Active now")
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
    
    
    
    private func startProfileRotation() {
        guard !profileViewModel.activeUsers.isEmpty else { return }
        var index = 0
        //  var questionIndex = 0
        self.currentActiveUser = profileViewModel.activeUsers[0]
        self.timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect().sink { output in
            if !profileViewModel.activeUsers.isEmpty {
                index = (index + 1) % profileViewModel.activeUsers.count
                self.currentActiveUser = profileViewModel.activeUsers[index]
                
                qaViewModel.quickChatQuestion =  qaViewModel.questions.randomElement() ?? emptyQuestionModel
            } else {
                self.currentActiveUser = emptyProfileModel
            }
        }
    }
    
    private func getActiveUsers() async throws {
        try await profileViewModel.GetActiveUsers()
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
        switch selectedButton {
        case 0:
            return .blue
        case 1:
            return .green
        case 2:
            return .green
        default:
            return .blue
            
        }
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
