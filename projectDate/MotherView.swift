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
                        Label("Home", systemImage: "house")
                    }.tag(1)
                LikesView()
                    .tabItem{
                        Label("Likes", systemImage: "heart")
                    }
                    .tag(2)
                MatchBoxPortalView()
                    .tabItem{
                        Label("CodeName", systemImage: "star")
                    }
                    .tag(3)
                MessageView()
                    .tabItem{
                        Label("Messenger", systemImage: "message")
                    }.tag(4)
                ProfileView()
                    .tabItem{
                        Label("Profile", systemImage: "person")
                    }.tag(5)
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
