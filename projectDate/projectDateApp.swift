//
//  projectDateApp.swift
//  projectDate
//
//  Created by DotZ3R0 on 8/2/22.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import FacebookCore
import FirebaseMessaging

@main
struct projectDateApp: App {
    @StateObject var viewRouter = ViewRouter()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewRouter)
        }
    }
}
