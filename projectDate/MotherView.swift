//
//  MotherView.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/4/22.
//

import SwiftUI

struct MotherView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var viewModel = HomeViewModel()
    
    //Change the menuBar color to white
    init() {
        UITabBar.appearance().backgroundColor = UIColor.darkGray
    }
    
    var body: some View {
        GeometryReader{geoReader in
            switch viewRouter.currentPage {
            case .homePage :
                TabView {
                    HomeView()
                        .tabItem{
                            Label("Home", systemImage: "house")
                        }.tag(1)
                    EventHomeView()
                        .tabItem{
                            Label("Events", systemImage: "calendar")
                        }.tag(2)
                    MessageHomeView()
                        .tabItem{
                            Label("Messenger", systemImage: "message")
                        }.tag(3)
                    SettingsView()
                        .tabItem{
                            Label("Settings", systemImage: "gearshape")
                        }.tag(4)
                }
                .frame(height: geoReader.size.height * 1.07)
                
            case .signUpPage :
                SignUpView()
            case .signInPage:
                SignInView()
            case .confirmationPage:
                ConfirmationView()
            case .failedPage:
                FailedView()
            case .matchPage:
                MatchView()
            case .scheduleSpeedDatePage:
                ScheduleSpeedDateView()
            }
        }
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView().environmentObject(ViewRouter())
    }
}
