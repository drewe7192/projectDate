//
//  MotherView.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/4/22.
//

import SwiftUI

struct MotherView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
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
                            Label("Live", systemImage: "livephoto")
                        }.tag(1)
                    EventHomeView()
                        .tabItem{
                            Label("Current", systemImage: "calendar")
                        }.tag(2)
                    MessageHomeView()
                        .tabItem{
                            Label("Connect", systemImage: "point.3.connected.trianglepath.dotted")
                        }.tag(3)
                    MessageHomeView()
                        .tabItem{
                            Label("Discover", systemImage: "globe")
                        }.tag(4)
                    SettingsView()
                        .tabItem{
                            Label("Settings", systemImage: "gearshape")
                        }.tag(5)
                }
                .frame(height: geoReader.size.height * 1.07)
                
            case .signUpPage :
                SignUpView()
            case .signInPage:
                SignInView()
            case .confirmationPage:
                ConfirmationView(confirmationText: "New card Created")
            case .failedPage:
                FailedView()
            case .matchPage:
                MatchView()
            case .scheduleSpeedDatePage:
                ScheduleSpeedDateView()
            case .speedDateConfirmationPage:
                ConfirmationView(confirmationText: "SpeedDate created!")
            case .speedDateEndedPage:
                SpeedDateEndedPage()
            }
        }
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView().environmentObject(ViewRouter())
    }
}
