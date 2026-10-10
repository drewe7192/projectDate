//
//  ViewRouter.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/4/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ViewRouter: ObservableObject {
    static let shared = ViewRouter()
    @Published var currentPage: Route = .signInPage
    
    init(){
        run()
    }
    
    func run(){
        Auth.auth().addStateDidChangeListener { auth, user in
            // Dispatch to the main thread since UI updates must happen on MainActor
            DispatchQueue.main.async {
                if user != nil {
                    // 🔑 If a user session exists, automatically route them straight home
                    self.currentPage = .homePage
                } else {
                    // 🔑 If no user is authenticated, route them to the sign-in screen
                    self.currentPage = .signInPage
                }
            }
        }
    }
}

enum Route {
    case signUpPage
    case signInPage
    case homePage
    case settingsPage
    case videoPage(videoConfig: VideoConfigModel)
    case notificationsPage
    case speedDateLobby
}
