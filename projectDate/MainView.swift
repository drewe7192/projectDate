//
//  ContentView.swift
//  projectDate
//
//  Created by DotZ3R0 on 8/2/22.
//

import SwiftUI

struct MainView: View {
    
    @State var isPresenting = false
    @State private var selectedItem = 1
    @State private var oldSelectedItem = 1
    var body: some View {
        TabView {
            HomeView()
                .tabItem{
                    Label("Home", systemImage: "house")
                }.tag(1)
            ProfileView()
                .tabItem{
                    Label("Profile", systemImage: "message")
                }.tag(2)
            MessageView()
                .tabItem{
                    Label("Messenger", systemImage: "message")
                }.tag(3)
            LogOutView()
                .tabItem{
                    Label("LogOut", systemImage: "pencil")
                }.tag(4)
        }
    }
}

    struct MainView_Previews: PreviewProvider {
        static var previews: some View {
            MainView()
        }
    }
