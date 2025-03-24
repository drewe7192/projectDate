//
//  HomeView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 2/18/25.
//

import SwiftUI
import Combine
import HMSRoomKit

struct HomeView: View {
    @State private var isSearching: Bool = false
    @State private var name: String = ""
    @State private var roomCode: String = ""
    @State var timer: AnyCancellable?
    @State var isGuestJoining = false
    @State var isSettingsView = false
    @State private var hasTimeElapsed = false
    @EnvironmentObject var profileViewModel: ProfileViewModel
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack{
              //  header()
                
                if !profileViewModel.userProfile.roomCode.isEmpty {
                      HMSPrebuiltView(roomCode: profileViewModel.userProfile.roomCode)
                } else {
                    Text("...Loading")
                        .font(.system(size: 50))
                        .bold()
                }
               // footer()
              //  speedDateTiles()
            }
       
        }
        .task {
            do {
                try await profileViewModel.GetUserProfile()
                try await getActiveUsers()
                startRotation(with: profileViewModel.activeUsers)
            } catch {
                // HANDLE ERROR
            }
        }
    }
    
    private func header() -> some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 40)
                    .fill(.gray)
                    .opacity(0.3)
                    .frame(width: 350, height: 80)
                
                if isSearching {
                    HStack{
                        Text("Searching for Friends")
                        ProgressView()
                    }
                } else {
                    VStack{
                        Text("\(self.name) wants to connect")
                            .id(self.name)
                            .transition(.opacity.animation(.smooth))
                        
                        HStack{
                            Button(action: {
                                if let pickedUser = profileViewModel.activeUsers.first(where: {$0.name == self.name}) {
                                    Task {
                                        // this removes HMSPreBuiltView and triggers its onDisappear()
                                        self.roomCode = ""
                                        // Delay of 7.5 seconds (1 second = 1_000_000_000 nanoseconds)
                                        try? await Task.sleep(nanoseconds: 7_500_000_000)
                                        self.roomCode = pickedUser.roomCode
                                    }
                                }
                                
                                
                                
                            }) {
                                Text("Connect")
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                    .background(Color.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                            
                            Button(action: {
                                
                            }) {
                                Text("Cancel")
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                    .background(Color.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                        }
                    }
                }
            }
        }
    }
    private func footer() -> some View {
        VStack{
            if isSettingsView {
                SettingsView()
            }
            
            Button(action: {
                isSettingsView.toggle()
            }) {
                Text("Settings")
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
    }
    
    private func speedDateTiles() -> some View {
        VStack{
            Text("Upcoming Events")
                .bold()
                .font(.system(size: 25))
            ScrollView(.horizontal) {
                
                HStack{
                    ForEach(1...3, id: \.self) {_ in
                        ZStack{
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.gray)
                                .opacity(0.3)
                                .frame(width: 200, height: 200)
                            VStack{
                                Text("Title")
                                Text("Event Date: Jan 3")
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func startRotation(with activeProfiles: [ProfileModel]) {
        guard !activeProfiles.isEmpty else { return }
        
        var index = 0
        self.name = activeProfiles[0].name
        self.timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect().sink { output in
            index = (index + 1) % activeProfiles.count
            self.name = activeProfiles[index].name
        }
    }
    
    private func getActiveUsers() async throws {
        try await profileViewModel.GetActiveUsers()
    }
}

#Preview {
    HomeView()
        .environmentObject(ProfileViewModel())
}

