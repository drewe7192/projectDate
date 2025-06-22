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
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var delegate: AppDelegate
    @EnvironmentObject var videoViewModel: VideoViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    @EnvironmentObject var qaViewModel: QAViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    
    @Binding var selectedTab: Int
    
    @State private var selectedButton: Int = 0
    @State var timer: AnyCancellable?
    @State private var currentActiveUser: ProfileModel = emptyProfileModel
    @State private var videoConfig: VideoConfigModel = emptyVideoConfig
    @State private var answer: String = ""
    @State private var quickChatQuestion: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.primaryColor
                    .ignoresSafeArea()
                
                VStack{
                    header()
                    Spacer()
                        .frame(height: 10)
                    quickChat()
                    Spacer()
                        .frame(height: 10)
                    videoSection()
                    events()
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
    }
    
    private func header() -> some View {
        VStack{
            HStack{
                Circle()
                    .frame(width: 30)
                    .overlay {
                        if !profileViewModel.userProfile.profileImage.size.height.isZero {
                            Circle()
                                .overlay(
                                    Image(uiImage: profileViewModel.userProfile.profileImage)
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                )
                                .frame(width: 35, height: 35)
                            
                        } else {
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 15, height: 15)
                        }
                        
                    }
                    .padding(.leading)
                    .onTapGesture {
                        selectedTab = 2
                    }
                
                Spacer()
                
                Text("LittleBigThings")
                    .font(.custom("Copperplate", size: 20))
                    .foregroundColor(Color("tertiaryColor"))
                    .bold()
                
                Image("logo")
                    .resizable()
                    .frame(width: 25, height: 25)
                
                Spacer()
                
                Button(action : {
                    viewRouter.currentPage = .notificationsPage
                }){
                    Image(systemName: "bell.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundColor(Color("tertiaryColor"))
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .clipShape(Circle())
                }
            }
        }
    }
    
    private func quickChat() -> some View {
        VStack{
            RoundedRectangle(cornerRadius: 20)
                .stroke(changeColor(), lineWidth: 2)
                .frame(width: 380, height: 180)
                .opacity(selectedButton != 0 ? 0.5 : 1.0)
                .animation(.easeInOut, value: true)
                .overlay {
                    VStack {
                        connectSection()
                        Spacer()
                        questionSection()
                    }
                    .padding(10)
                }
        }
    }
    
    private func videoSection() -> some View {
        VStack {
            if !videoViewModel.roomCode.isEmpty {
                VideoView(videoConfig: videoConfig)
            }
            else {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.primaryColor)
                    .frame(width: 350, height: 400)
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
    
    private func events() -> some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    ForEach(0...4, id: \.self) {_ in
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.blue, lineWidth: 2)
                            .frame(width: 340, height: 100)
                            .overlay{
                                HStack{
                                    HStack(spacing: -15) {
                                        ForEach(0...4, id: \.self) { _ in
                                            HStack(spacing: 0) {
                                                Circle()
                                                    .overlay {
                                                        Image(systemName: "person.fill")
                                                            .resizable()
                                                            .frame(width: 25, height: 25)
                                                            .foregroundColor(.black)
                                                    }
                                                    .foregroundColor(.gray)
                                                    .frame(width: 30,height: 30)
                                            }
                                        }
                                    }
                                    
                                    Text("Meet 1")
                                        .foregroundColor(Color("tertiaryColor"))
                                        .font(.system(size: 20))
                                        .bold()
                                        .padding(.bottom,5)
                                    
                                    HStack{
                                        Text("3/3/25 @4pm")
                                            .foregroundColor(Color("tertiaryColor"))
                                            .font(.system(size: 10))
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
    
    private func connectSection() -> some View {
        HStack{
            quickChatProfileSection()
            
            Spacer()
            
            Button(action:  {
                if let pickedUser = profileViewModel.activeUsers.first(where: {$0.id == self.currentActiveUser.id}) {
                    Task {
                        profileViewModel.participantProfile = pickedUser
                        try await sendRequestMessage(pickedUser: pickedUser)
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
        }
    }
    
    private func questionSection() -> some View {
        VStack{
            Text("\(self.quickChatQuestion)")
                .bold()
                .font(.title3)
                .animation(.easeInOut)
                .foregroundColor(.white)

            HStack(spacing: 5) {
                TextField("Type in answer", text: $answer)
                    .foregroundColor(.gray)
                    .frame(width: 220, height: 15)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .textInputAutocapitalization(.never)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color.primaryColor, lineWidth: 1)
                    )
                
                Button(action:  {
                    
                }) {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color("tertiaryColor"), lineWidth: 2)
                        .frame(width: 70, height: 45)
                        .overlay {
                            Text("Send")
                                .foregroundColor(.white)
                        }
                }
            }
            
        }
    }
    
    private func quickChatProfileSection() -> some View {
        HStack {
            Circle()
                .frame(width: 35)
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
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    }
                    
                }
                .foregroundColor(Color.secondaryColor)
            
            VStack{
                if selectedButton == 0 {
                    if !self.currentActiveUser.name.isEmpty {
                        VStack(alignment: .leading) {
                            Text("\(self.currentActiveUser.name)")
                                .bold()
                                .font(.title3)
                                .id(self.currentActiveUser.id)
                                .transition(.opacity.animation(.smooth))
                                .foregroundColor(Color("tertiaryColor"))
                            
                            Text("Active now")
                                .foregroundColor(Color("tertiaryColor"))
                                .font(.system(size: 10))
                        }
                        
                        
                    } else {
                        Text("Searching for friends...")
                            .foregroundColor(Color("tertiaryColor"))
                    }
                    
                } else if selectedButton == 1 {
                    
                    Text("Request Sent Successfully!")
                        .foregroundColor(Color("tertiaryColor"))
                }
            }
        }
    }
    
    
    
    private func startProfileRotation() {
        guard !profileViewModel.activeUsers.isEmpty else { return }
        var index = 0
        self.currentActiveUser = profileViewModel.activeUsers[0]
        self.timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect().sink { output in
            if !profileViewModel.activeUsers.isEmpty {
                index = (index + 1) % profileViewModel.activeUsers.count
                self.currentActiveUser = profileViewModel.activeUsers[index]
                self.quickChatQuestion = qaViewModel.questions.randomElement()?.body ?? ""
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
            return .red
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
