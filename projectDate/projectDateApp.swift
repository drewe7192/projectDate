//
//  projectDateApp.swift
//  projectDate
//
//  Created by Drew Sutherlan on 8/2/22.
//

import SwiftUI
import Firebase

@main
struct projectDateApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
