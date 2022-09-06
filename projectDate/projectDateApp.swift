//
//  projectDateApp.swift
//  projectDate
//
//  Created by DotZ3R0 on 8/2/22.
//

import SwiftUI
import Firebase

@main
struct projectDateApp: App {
    
    @StateObject var viewRouter = ViewRouter()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MotherView().environmentObject(viewRouter)
        }
    }
}
