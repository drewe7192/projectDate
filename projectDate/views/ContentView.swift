//
//  MotherView.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/4/22.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var delegate: AppDelegate
    
    @StateObject var profileViewModel = ProfileViewModel()
    @StateObject var videoViewModel = VideoViewModel()
    @StateObject var qaViewModel = QAViewModel()
    
    var body: some View {
        switch viewRouter.currentPage {
        case .homePage :
            MainView()
                .environmentObject(profileViewModel)
                .environmentObject(videoViewModel)
                .environmentObject(qaViewModel)
        case .signUpPage:
            SignUpView()
        case .signInPage:
            SignInView()
        case .settingsPage:
            SettingsView()
        case .videoPage:
            VideoView(isFullScreen: delegate.isFullScreen)
                .environmentObject(profileViewModel)
                .environmentObject(videoViewModel)
                .environmentObject(qaViewModel)
        case .requestPage:
            RequestView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewRouter())
}
