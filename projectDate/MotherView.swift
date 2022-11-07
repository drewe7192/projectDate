//
//  MotherView.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/4/22.
//

import SwiftUI

struct MotherView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        switch viewRouter.currentPage {
        case .signInPage :
            TabView {
                HomeView()
                    .tabItem{
                        Label("Home", systemImage: "message")
                    }.tag(1)
                ProfileView()
                    .tabItem{
                        Label("Profile", systemImage: "message")
                    }.tag(2)
                MessageView()
                    .tabItem{
                        Label("Messenger", systemImage: "message")
                    }.tag(3)
            }
        case .signUpPage :
            SignUpView()
        case . homePage:
       SignInView()
        }

      
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView().environmentObject(ViewRouter())
    }
}
