//
//  HomeView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 2/18/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.scenePhase) private var phase
    @State private var tabSelection = 1
    @State private var timeRemaining = 10
    @State private var showAlert: Bool = false
    
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        LiveView()
//        LiveView(tabSelection: $tabSelection, showAlert: $showAlert)
//            .tabItem{
//                Label("Live", systemImage: "livephoto")
//            }.tag(1)
//            .onReceive(timer) { time in
//                if timeRemaining > 0 && tabSelection == 1 {
//                    timeRemaining -= 1
//                }else if timeRemaining == 0 && tabSelection == 1 {
//                    showAlert = true
//                    timeRemaining += 10
//                }
//            }
    }
}

func notifyPeerInRoom() {
    @StateObject var viewModel = LiveViewModel()
    
// calling the viewModel will return a purple error about StateObject
    viewModel.getUserProfileForBackground() {(profile) -> Void in
        if !profile.fcmTokens.isEmpty {
            viewModel.checkForPeer(userProfileBackground: profile)
        }
    }
}

public func runBackgroundTasks(){
    notifyPeerInRoom()
}

#Preview {
    HomeView()
}

