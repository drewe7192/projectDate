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
                            Label("Home", systemImage: "house")
                        }.tag(1)
                    EventHomeView()
                        .tabItem{
                            Label("Events", systemImage: "calendar")
                        }.tag(2)
                    SettingsView()
                        .tabItem{
                            Label("Settings", systemImage: "gearshape")
                        }.tag(3)
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
            }
        }
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView().environmentObject(ViewRouter())
    }
}
