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
            case.onBoardingPage:
                OnBoardingView()
                    .environmentObject(profileVM)
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
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewRouter())
        .environmentObject(ProfileViewModel())
        .environmentObject(SpeedDateViewModel())
}
