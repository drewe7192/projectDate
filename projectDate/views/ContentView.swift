//
//  MotherView.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/4/22.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var speedDateVM: SpeedDateViewModel
    @EnvironmentObject var videoVM: VideoViewModel
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var eventViewModel = EventViewModel()
    
    var body: some View {
        ZStack {
            // 1. Main Navigation Routing Switch
            switch viewRouter.currentPage {
            case .homePage:
                MainView()
                    .environmentObject(profileViewModel)
                    .environmentObject(speedDateVM)
                    .environmentObject(eventViewModel)
                    .onChange(of: scenePhase) { oldPhase, newPhase in
                        updateActiveStatus(newPhase: newPhase)
                    }
            case .signUpPage:
                SignUpView()
                    .environmentObject(profileViewModel)
            case .signInPage:
                SignInView()
            case .settingsPage:
                SettingsView()
            case .notificationsPage:
                NotificationsView()
            case .speedDateLobby:
                SpeedDateLobbyView()
                    .environmentObject(eventViewModel)
                    .environmentObject(speedDateVM)
                    .environmentObject(videoVM)
            case .videoPage:
                Color.clear
            }
            
            
            if case .videoPage(let videoConfig) = viewRouter.currentPage {
                VideoView(videoConfig: videoConfig)
                    .transition(.opacity) // Smooth entry transition
            }
        }
        .environmentObject(profileViewModel)
        .environmentObject(speedDateVM)
        .environmentObject(eventViewModel)
        .onChange(of: scenePhase) { oldPhase, newPhase in
            updateActiveStatus(newPhase: newPhase)
        }
    }
    
    private func updateActiveStatus(newPhase: ScenePhase) {
        if newPhase == .active {
            if !profileViewModel.userProfile.id.isEmpty {
                Task{
                    try await profileViewModel.UpdateActivityStatus(isActive: true)
                }
            }
        } else if newPhase == .inactive {
            if !profileViewModel.userProfile.id.isEmpty {
                Task {
                    try await
                    profileViewModel.UpdateActivityStatus(isActive: false)
                }
            }
        } else if newPhase == .background {

        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewRouter())
        .environmentObject(ProfileViewModel())
        .environmentObject(SpeedDateViewModel())
}
