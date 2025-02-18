//
//  projectDateApp.swift
//  projectDate
//
//  Created by DotZ3R0 on 8/2/22.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging
import GoogleSignIn
import FacebookCore

class AppDelegate: UIResponder, UIApplicationDelegate{
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchingOptions:
                            [UIApplication.LaunchOptionsKey : Any]?) -> Bool{
        return true
    }
    
    //Facebook and Google Auth
    public func application(_ application: UIApplication, open url: URL,
                            options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
//        FacebookCore.ApplicationDelegate.shared.application(
//            application,
//            open: url,
//            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//        )
        
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct projectDateApp: App {
    @StateObject var viewRouter = ViewRouter()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewRouter)
        }
    }
}
