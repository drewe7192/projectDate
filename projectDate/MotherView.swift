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
        GeometryReader{geoReader in
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
                            Label("Settings", systemImage: "gearshape")
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
                .frame(height: geoReader.size.height * 1.05)
                
            case .signUpPage :
                SignUpView()
            case .signInPage:
                SignInView()
            case .confirmationPage:
                ConfirmationView()
            }
        }
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView().environmentObject(ViewRouter())
    }
}
