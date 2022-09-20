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
                    Label("Home", systemImage: "MainViewhouse")
                }.tag(1)
            ProfileView()
                .tabItem{
                    Label("Profile", systemImage: "MainViewmessage")
                }.tag(2)
            MessageView()
                .tabItem{
                    Label("Messenger", systemImage: "message")
                }.tag(3)
        }
    }
}

    struct MainView_Previews: PreviewProvider {
        static var previews: some View {
            MainView()
        }
    }
