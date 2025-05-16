//
//  MotherView.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/4/22.
//
import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var profileViewModel = ProfileViewModel()
    @StateObject var videoViewModel = VideoViewModel()
    @StateObject var qaViewModel = QAViewModel()
    
    init() {
        
    }
    
    var body: some View {
        switch viewRouter.currentPage {
        case .homePage :
            MainView()
                .environmentObject(profileViewModel)
                .environmentObject(videoViewModel)
                .environmentObject(qaViewModel)
                .onChange(of: scenePhase) { oldPhase, newPhase in
                    if newPhase == .active {
                        print("Active")
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
        case .signUpPage:
            SignUpView()
        case .signInPage:
            SignInView()
        case .settingsPage:
            SettingsView()
        case .videoPage:
            VideoView(isFullScreen: .constant(true))
                .environmentObject(profileViewModel)
                .environmentObject(videoViewModel)
                .environmentObject(qaViewModel)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewRouter())
}
