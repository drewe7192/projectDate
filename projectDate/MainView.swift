//
//  ContentView.swift
//  projectDate
//
//  Created by DotZ3R0 on 8/2/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem{
                    Label("Home", systemImage: "house")
                }
            ProfileView()
                .tabItem{
                    Label("Profile", systemImage: "person")
                }
            MessageView()
                .tabItem{
                    Label("Messenger", systemImage: "message")
                }
           
        }
       
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
