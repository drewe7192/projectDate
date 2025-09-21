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
            if auth.currentUser != nil {
                self.currentPage = .homePage
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
    case requestPage
    case notificationsPage
    case walkThroughPage
}
