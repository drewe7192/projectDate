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
    //Conntecing App Delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewRouter = ViewRouter()
    
    //init firebase
//    init(){
//        initFirebase()
//    }
    
    var body: some Scene {
        WindowGroup {
            MotherView().environmentObject(viewRouter)
        }
    }
}

//extension projectDateApp {
//    private func initFirebase(){
//        FirebaseApp.configure()
//    }
//}



class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchingOptions:
                     [UIApplication.LaunchOptionsKey : Any]?) -> Bool{
        
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
        FacebookCore.ApplicationDelegate.shared.application(
            application,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        return GIDSignIn.sharedInstance.handle(url)
    }
}

