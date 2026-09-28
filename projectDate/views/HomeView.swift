//
//  HomeView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 2/18/25.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @State private var videoConfig: VideoConfigModel = emptyVideoConfig
    @State private var isHeartSelected: Bool = false
    @State private var showingNewAnswersSheet = false
    @State private var selectedOptions: Set<String> = []
    @State private var navigateToSpeedDate = false
    
    @StateObject private var toastManager = ToastManager.shared
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var videoViewModel: VideoViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { geometry in
                    AnimatedGradientBackground()
                        .ignoresSafeArea()
                    
                    VStack{
                        header(geometry: geometry)
                        
                        Spacer()
                            .frame(height: geometry.size.height * 0.03)
                        
                        videoSection(geometry: geometry)
                        
                        Spacer()
                            .frame(height: geometry.size.height * 0.03)
                        
                                                GlassContainer {
                                                    VStack{
                                                        Button(action: {
                                                            navigateToSpeedDate = true
                                                            viewRouter.currentPage = .speedDateLobby
                                                        }) {
                                                            VStack{
                                                                Text("Start Speed Date")
                                                                    .foregroundStyle(.white)
                                                                    .font(.system(size: 20))
                                                            }
                                                        }
                                                    }
                                                    
                                                    NavigationLink(
                                                        destination: SpeedDateLobbyView(), // The next screen
                                                        isActive: $navigateToSpeedDate,
                                                        label: {
                                                            EmptyView() // Hidden link
                                                        }
                                                    )
                                                }
                                                .frame(height: geometry.size.height * 0.1)
                                                .disabled(false)
                                                .opacity(0.5)
                        
                        //                        Text("Please report inappropriate behavior to support@LittleBigThings.com")
                        //                            .font(.footnote)
                        //                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
            }
            .task {
                if let _ = Auth.auth().currentUser {
                    do {
                        /// get profile and launch video
                        try await profileViewModel.GetUserProfile()
                        
                        // Only set roomCode if userProfile exists
                        if !profileViewModel.userProfile.roomCode.isEmpty {
                            videoViewModel.roomCode = profileViewModel.userProfile.roomCode
                        }
                        
                        try await profileViewModel.getFileFromStorage(profileId: profileViewModel.userProfile.id)
                        try await profileViewModel.UpdateActivityStatus(isActive: true)
                    } catch {
                        print("Error getting userProfile:\(error)")
                    }
                }
            }
            .ignoresSafeArea(.keyboard)
        }
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
                    selectedTab = 1
                }
            
            Spacer()
            
            //            Text("LittleBigThings")
            //                .font(.custom("Copperplate", size: geometry.size.height * 0.03))
            //                .foregroundColor(Color("tertiaryColor"))
            //                .bold()
            
            Image("logo")
                .resizable()
                .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
            
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
    
    private func videoSection(geometry: GeometryProxy) -> some View {
        VStack {
            if !videoViewModel.roomCode.isEmpty {
                VideoView(videoConfig: videoConfig)
            }
            else {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.primaryColor)
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.2)
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
    
    private func introSheet() -> some View {
        ZStack{
            Color.primaryColor
                .ignoresSafeArea()
            
            VStack{
                Text("Features:")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                
                
                Text("Q&A")
                    .foregroundColor(.white)
                    .font(.title)
                
                Text("BlindChat")
                    .foregroundColor(.white)
                    .font(.title)
                
            }
        }
    }
    
    private func launchVideoSession(pickedUser: ProfileModel) async throws {
        // this removes HMSPreBuiltView and triggers its onDisappear()
        // makes sure current video sesh has closed
        videoViewModel.roomCode = ""
        
        // Delay of 5 seconds (1 second = 1_000_000_000 nanoseconds)
        try? await Task.sleep(for: .seconds(5))
        
        videoViewModel.roomCode = pickedUser.roomCode
        //viewRouter.currentPage = .videoPage
    }
}

#Preview {
    HomeView(selectedTab: .constant(0))
        .environmentObject(ProfileViewModel())
        .environmentObject(VideoViewModel())
        .environmentObject(AppDelegate())
}
