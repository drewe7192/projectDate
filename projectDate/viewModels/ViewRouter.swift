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
    @Published var currentPage: Route = .signUpPage
    
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
    case onBoardingPage
}
