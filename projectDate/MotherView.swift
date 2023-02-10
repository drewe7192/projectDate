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
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        switch viewRouter.currentPage {
        case .homePage :
            TabView {
                LocalHomeView()
                    .tabItem{
                        Label("Home", systemImage: "house")
                    }.tag(1)
                EventHomeView(searchText: .constant(""))
                    .tabItem{
                        Label("Events", systemImage: "calendar")
                    }.tag(2)
                SettingsView()
                    .tabItem{
                        Label("Settings", systemImage: "calendar")
                    }.tag(3)
                //                HomeView()
                //                    .tabItem{
                //                        Label("Home", systemImage: "house")
                //                    }.tag(1)
                //                LikesView()
                //                    .tabItem{
                //                        Label("Likes", systemImage: "heart")
                //                    }
                //                    .tag(2)
                //                GamesView()
                //                    .tabItem{
                //                        Label("Games", systemImage: "gamecontroller")
                //                    }
                //                    .tag(3)
                //                MessageHomeView()
                //                    .tabItem{
                //                        Label("Messenger", systemImage: "message")
                //                    }.tag(4)
                //                UserProfileView()
                //                    .tabItem{
                //                        Label("Profile", systemImage: "person")
                //                    }.tag(5)
            }
            .frame(height: 850)
            
        case .signUpPage :
            SignUpView()
        case .signInPage:
            SignInView()
        }
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView().environmentObject(ViewRouter())
    }
}
