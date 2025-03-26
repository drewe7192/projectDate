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
    @Environment(\.scenePhase) var scenePhase
    
    init() {

    }
    
    var body: some View {
            GeometryReader{ geoReader in
                switch viewRouter.currentPage {
                case .homePage :
                    HomeView()
                        .environmentObject(profileViewModel)
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
                }
            }
    }
    
    #Preview {
        ContentView()
            .environmentObject(ViewRouter())
    }
}
