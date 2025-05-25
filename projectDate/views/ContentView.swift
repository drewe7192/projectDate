//
//  MotherView.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/4/22.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
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
        case .signUpPage:
            SignUpView()
        case .signInPage:
            SignInView()
        case .settingsPage:
            SettingsView()
        case .videoPage:
            VideoView(isFullScreen: true)
                .environmentObject(profileViewModel)
                .environmentObject(videoViewModel)
                .environmentObject(qaViewModel)
                .environmentObject(eventViewModel)
        case .requestPage:
            RequestView()
                .environmentObject(profileViewModel)
                .environmentObject(eventViewModel)
                .environmentObject(videoViewModel)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewRouter())
}
