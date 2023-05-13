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

//FirebaseMessaging might already be importing this
//import UserNotifications

@main
struct projectDateApp: App {
    //Linking App Delegate to your App
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var viewRouter = ViewRouter()
    
    var body: some Scene {
        WindowGroup {
            MotherView().environmentObject(viewRouter)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate{
    let gcmMessageIDKey = "gcm.message_id"
    
    //Executed once the app finished launching
   public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchingOptions:
                     [UIApplication.LaunchOptionsKey : Any]?) -> Bool{
        
        //Initializing Firebase
        FirebaseApp.configure()
        
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
        
        print(userInfo)
        
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

extension AppDelegate: MessagingDelegate {
    
    //prints the device token
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let deviceToken:[String: String] = ["token": fcmToken ?? ""]
        print("Device token: ", deviceToken) // This token can be used for testing notifications on FCM
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    //Notification Center
    //This is where all the notification actions are handled
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([[.banner, .badge, .sound]])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID from userNotificationCenter didReceive: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler()
    }
}
