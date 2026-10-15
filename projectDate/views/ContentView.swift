//
//  MotherView.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/4/22.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var speedDateVM: SpeedDateViewModel
    @EnvironmentObject var videoVM: VideoViewModel
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var eventVM = EventViewModel()
    
    var body: some View {
        ZStack {
            switch viewRouter.currentPage {
            case .homePage:
                MainView()
                    .environmentObject(profileVM)
                    .environmentObject(speedDateVM)
                    .environmentObject(eventVM)
                    .onChange(of: scenePhase) { oldPhase, newPhase in
                        updateActiveStatus(newPhase: newPhase)
                    }
            case .signUpPage:
                SignUpView()
                    .environmentObject(profileVM)
            case .signInPage:
                SignInView()
            case .settingsPage:
                SettingsView()
            case .notificationsPage:
                NotificationsView()
            case .speedDateLobby:
                SpeedDateLobbyView()
                    .environmentObject(eventVM)
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
        .environmentObject(profileVM)
        .environmentObject(speedDateVM)
        .environmentObject(eventVM)
        .onChange(of: scenePhase) { oldPhase, newPhase in
            updateActiveStatus(newPhase: newPhase)
        }
    }
    
    private func updateActiveStatus(newPhase: ScenePhase) {
        if newPhase == .active {
            if !profileVM.userProfile.id.isEmpty {
                Task{
                    try await profileVM.updateActivityStatus(isActive: true)
                }
            }
        } else if newPhase == .inactive {
            if !profileVM.userProfile.id.isEmpty {
                Task {
                    try await
                    profileVM.updateActivityStatus(isActive: false)
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
