//
//  HomeView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 2/18/25.
//

import SwiftUI
import Combine
import HMSRoomKit
import FirebaseMessaging
import FirebaseFunctions

struct HomeView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var videoViewModel: VideoViewModel
    @EnvironmentObject var delegate: AppDelegate
    @EnvironmentObject var viewRouter: ViewRouter
    @Binding var selectedTab: Int
    @State var timer: AnyCancellable?
    @State private var name: String = ""
    @State var helloWorldMsg: String = "function not called yet"
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                VStack{
                    header()
                    Text("\(delegate.requestMessage)")
                        .foregroundColor(.red)
                    Spacer()
                    
                    quickChat()
                    videoSection()
                    
                    events()
                    
                    Spacer()
                }
            }
            .task {
                do {
                    /// get profile and launch video
                    try await profileViewModel.GetUserProfile()
                    videoViewModel.roomCode = profileViewModel.userProfile.roomCode
                    
                    /// update user app status to active
                    try await profileViewModel.UpdateActivityStatus(isActive: true)
                    
                    /// for quickChat
                    try await getActiveUsers()
                    startProfileRotation()
                    
                } catch {
                    // HANDLE ERROR
                }
            }
            /// update foreground and background  status in db
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    print("Active \(profileViewModel.userProfile.id)")
                    if profileViewModel.userProfile.id != "" {
                        Task{
                            try await profileViewModel.UpdateActivityStatus(isActive: true)
                        }
                        
                    }
                } else if newPhase == .inactive {
                    print("Inactive")
                    if profileViewModel.userProfile.id != "" {
                        Task {
                            try await
                            profileViewModel.UpdateActivityStatus(isActive: false)
                        }
                        
                    }
                } else if newPhase == .background {
                    print("Background")
                }
            }
            /// display requestView once user recieves request for BlindDate
            .onChange(of: delegate.requestMessage) { oldValue, newValue in
                viewRouter.currentPage = .requestPage
            }
        }
    }
    
    private func header() -> some View {
        VStack{
            HStack{
                Circle()
                    .frame(width: 30)
                    .overlay {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.black)
                    }
                    .padding(.leading)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        selectedTab = 1
                    }
                
                HStack(spacing: 0){
                    Text("Hello,")
                        .font(.title3)
                        .foregroundColor(.black)
                    
                    Text("Drew")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Image(systemName: "bell.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 30)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .clipShape(Circle())
            }
        }
    }
    
    private func quickChat() -> some View {
        VStack{
            RoundedRectangle(cornerRadius: 40)
                .fill(.gray)
                .opacity(0.3)
                .frame(width: 350, height: 60)
                .overlay {
                    HStack{
                        Circle()
                            .frame(width: 40)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.black)
                            }
                            .padding(.leading)
                            .foregroundColor(.gray)
                        
                        VStack{
                            Text("\(self.name)")
                                .bold()
                                .id(self.name)
                                .transition(.opacity.animation(.smooth))
                                .foregroundColor(.black)
                            
                            Text("Wants to connect")
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: -15){
                            Button(action: {
                                if let pickedUser = profileViewModel.activeUsers.first(where: {$0.name == self.name}) {
                                    Task {
                                        
//                                        let fcmToken = try await profileViewModel.GetFCMToken(userId: pickedUser.userId)
//
//                                        helloWorldMsg = try await profileViewModel.callSendNotification(fcmToken: fcmToken)
                                        
                                                                                    // this removes HMSPreBuiltView and triggers its onDisappear()
                                                                                    videoViewModel.roomCode = ""
                                        
                                                                                    // Delay of 5 seconds (1 second = 1_000_000_000 nanoseconds)
                                                                                    try? await Task.sleep(nanoseconds: 5_000_000_000)
                                        
                                                                                    videoViewModel.roomCode = pickedUser.roomCode
                                        
                                                                                    viewRouter.currentPage = .videoPage
                                        delegate.isFullScreen = .constant(true)
                                    }
                                }
                                
                            }) {
                                Image(systemName: "checkmark.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 35)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                    .background(Color.gray)
                                    .clipShape(Circle())
                            }
                            
                            Button(action: {
                                profileViewModel.activeUsers.removeAll(where: { $0.name == self.name })
                                startProfileRotation()
                            }) {
                                Image(systemName: "x.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 35)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                    .background(Color.gray)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
        }
    }
    
    private func videoSection() -> some View {
        VStack {
            if !videoViewModel.roomCode.isEmpty {
                VideoView(isFullScreen: delegate.isFullScreen)
            }
            else {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.white)
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
            Text("Upcoming Events")
                .bold()
                .font(.system(size: 20))
                .foregroundColor(.black)
            
            ScrollView(.vertical) {
                VStack{
                    ForEach(1...3, id: \.self) {_ in
                        HStack{
                            Spacer()
                            Circle()
                                .frame(width: 45)
                                .overlay {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.black)
                                }
                                .padding(.leading)
                                .foregroundColor(.gray)
                            
                            VStack{
                                Text("Facebook Arena")
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                                    .bold()
                                
                                HStack{
                                    Text("Community")
                                        .foregroundColor(.black)
                                        .font(.system(size: 10))
                                    
                                    Text("2 squad")
                                        .foregroundColor(.black)
                                        .font(.system(size: 10))
                                }
                                
                                NavigationLink(destination: EventView()) {
                                    Text("Choose Heads")
                                }
                                
                            }
                            
                            Spacer()
                            
                            Image(systemName: "ellipsis")
                                .foregroundColor(.black)
                                .rotationEffect(.degrees(-90))
                        }
                        .padding(.bottom)
                    }
                }
            }
        }
    }
    
    private func startProfileRotation() {
        guard !profileViewModel.activeUsers.isEmpty else { return }
        var index = 0
        self.name = profileViewModel.activeUsers[0].name
        self.timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect().sink { output in
            index = (index + 1) % profileViewModel.activeUsers.count
            self.name = profileViewModel.activeUsers[index].name
        }
    }
    
    private func getActiveUsers() async throws {
        try await profileViewModel.GetActiveUsers()
    }
}

#Preview {
    HomeView(selectedTab: .constant(0))
        .environmentObject(ProfileViewModel())
        .environmentObject(VideoViewModel())
        .environmentObject(AppDelegate())
}
