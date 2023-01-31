//
//  projectDateApp.swift
//  projectDate
//
//  Created by DotZ3R0 on 8/2/22.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FacebookCore
import FacebookLogin

@main
struct projectDateApp: App {
    //Connecting App Delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewRouter = ViewRouter()
    
    var body: some Scene {
        WindowGroup {
            MotherView().environmentObject(viewRouter)
        }
    }
}

//this use to be inheriting NsObject instead of UIResponder.. dont know why
class AppDelegate: UIResponder, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchingOptions:
                     [UIApplication.LaunchOptionsKey : Any]?) -> Bool{
        
        //Facebook auth
        FacebookCore.ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchingOptions
        )
        
        //Initializing Firebase
        FirebaseApp.configure()
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        
        //more Facebook Auth
        FacebookCore.ApplicationDelegate.shared.application(
            application,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        //        return GIDSignIn.sharedInstance.handle(url)
    }
}


