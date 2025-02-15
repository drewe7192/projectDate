//
//  projectDateApp.swift
//  projectDate
//
//  Created by DotZ3R0 on 8/2/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAnalytics
import FirebaseMessaging
import GoogleSignIn
import FacebookCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import BackgroundTasks

@main
struct projectDateApp: App {
    
    init(){
        FirebaseApp.configure()
    }

    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var viewRouter = ViewRouter()
    @Environment(\.scenePhase) private var phase
    
    var body: some Scene {
        WindowGroup {
            MotherView().environmentObject(viewRouter)
        }
        .onChange(of: phase) {oldValue, newPhase in
            switch newPhase {
            case .background: runBackgroundTasks()
            default: break
            }
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate{
    
    let gcmMessageIDKey = "gcm.message_id"
    
    //Executed once the app finished launching
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchingOptions:
                            [UIApplication.LaunchOptionsKey : Any]?) -> Bool{
        
        //Implement the messaging delegate protocol
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            //Asking the user for permission to send them push notifications
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        //Facebook auth
        FacebookCore.ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchingOptions
        )
        
        return true
    }
    
    //Listens to remote notifications and will alert the app when a new push notification comes in
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        //print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    //Facebook and Google Auth stuff
    public func application(_ application: UIApplication, open url: URL,
                            options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        
        //more Facebook Auth
        FacebookCore.ApplicationDelegate.shared.application(
            application,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        return GIDSignIn.sharedInstance.handle(url)
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

