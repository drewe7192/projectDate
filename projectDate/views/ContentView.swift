//
//  MotherView.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/4/22.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var profileViewModel = ProfileViewModel()
    @StateObject var videoViewModel = VideoViewModel()
    @StateObject var eventViewModel = EventViewModel()
    @StateObject var qaViewModel = QAViewModel()
    
    var body: some View {
        switch viewRouter.currentPage {
        case .homePage:
            MainView()
                .environmentObject(profileViewModel)
                .environmentObject(videoViewModel)
                .environmentObject(qaViewModel)
                .environmentObject(eventViewModel)
            /// update status in db whether app is in foreground and background
                .onChange(of: scenePhase) { oldPhase, newPhase in
                    updateActiveStatus(newPhase: newPhase)
                }
        case .signUpPage:
            SignUpView()
        case .signInPage:
            SignInView()
        case .settingsPage:
            SettingsView()
        case .videoPage(let videoConfig):
            VideoView(videoConfig: videoConfig)
                .environmentObject(profileViewModel)
                .environmentObject(videoViewModel)
                .environmentObject(qaViewModel)
                .environmentObject(eventViewModel)
            /// update status in db whether app is in foreground and background
                .onChange(of: scenePhase) { oldPhase, newPhase in
                    updateActiveStatus(newPhase: newPhase)
                }
        case .requestPage:
            RequestView()
                .environmentObject(profileViewModel)
                .environmentObject(eventViewModel)
                .environmentObject(videoViewModel)
                .animation(.easeInOut, value: true)
        case .notificationsPage:
            NotificationsView()
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
           // Todo
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewRouter())
}
