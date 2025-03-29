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
    @Binding var selectedTab: Int
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
                header()
                Spacer()
                quickChat()
                
                if !profileViewModel.userProfile.roomCode.isEmpty {
                    HMSPrebuiltView(roomCode: profileViewModel.userProfile.roomCode)
                        .frame(width: 350, height: 380)
                        .cornerRadius(30)
                } else {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.black)
                        .frame(width: 350, height: 400)
                }
                
                events()
                Spacer()
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
            HStack{
                Circle()
                    .frame(width: 35)
                    .overlay {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
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
                    .frame(height: 40)
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
                    if isSearching {
                        HStack{
                            Text("Searching for Friends")
                                .foregroundColor(.black)
                            ProgressView()
                        }
                    } else {
                        HStack{
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
                                Text("\(self.name)")
                                    .bold()
                                    .foregroundColor(.black)
                                
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
                                            // this removes HMSPreBuiltView and triggers its onDisappear()
                                            self.roomCode = ""
                                            // Delay of 7.5 seconds (1 second = 1_000_000_000 nanoseconds)
                                            try? await Task.sleep(nanoseconds: 7_500_000_000)
                                            self.roomCode = pickedUser.roomCode
                                        }
                                    }
                                    
                                }) {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 40)
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                        .padding(.vertical, 5)
                                        .background(Color.gray)
                                        .clipShape(Circle())
                                }
                                
                                Button(action: {
                                    
                                }) {
                                    Image(systemName: "x.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 40)
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
    }
    
    private func events() -> some View {
        VStack{
            Text("Upcoming Events")
                .bold()
                .font(.system(size: 20))
                .foregroundColor(.black)
            
            ScrollView(.horizontal) {
                HStack{
                    ForEach(1...3, id: \.self) {_ in
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.gray)
                            .opacity(0.3)
                            .frame(width: 250, height: 100)
                            .overlay {
                                VStack{
                                    Text("Title")
                                        .foregroundColor(.black)
                                    
                                    Text("Event Date: Jan 3")
                                        .foregroundColor(.black)
                                    Text("Sarah has one more spot for upcoming event")
                                        .foregroundColor(.black)
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
    HomeView(selectedTab: .constant(0))
        .environmentObject(ProfileViewModel())
}

