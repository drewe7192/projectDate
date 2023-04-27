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
import UserNotifications
import FirebaseMessaging


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
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchingOptions:
                     [UIApplication.LaunchOptionsKey : Any]?) -> Bool{

        //Facebook auth
        FacebookCore.ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchingOptions
        )

        //Initializing Firebase
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self

                if #available(iOS 10.0, *) {
                  // For iOS 10 display notification (sent via APNS)
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
        
        

        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
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

                return GIDSignIn.sharedInstance.handle(url)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

      let deviceToken:[String: String] = ["token": fcmToken ?? ""]
        print("Device token: ", deviceToken) // This token can be used for testing notifications on FCM
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
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



//class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
//      // ...
//      if let error = error {
//        print(error.localizedDescription)
//        return
//      }
//
//      guard let authentication = user.authentication else { return }
//      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                        accessToken: authentication.accessToken)
//      Auth.auth().signIn(with: credential) { (authResult, error) in
//        if let error = error {
//          print(error.localizedDescription)
//          return
//        }
//        print("signIn result: " + authResult!.user.email!)
//      }
//
//    }
//
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//        if let error = error {
//          print(error.localizedDescription)
//          return
//        }
//        // Perform any operations when the user disconnects from app here.
//        // ...
//    }
//
//
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        // Use Firebase library to configure APIs
//        FirebaseApp.configure()
//
//        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
//        GIDSignIn.sharedInstance().delegate = self
//
//        return true
//    }
//
//    @available(iOS 9.0, *)
//    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
//      -> Bool {
//      return GIDSignIn.sharedInstance().handle(url)
//    }
//
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        return GIDSignIn.sharedInstance().handle(url)
//    }
//
//    // MARK: UISceneSession Lifecycle
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
//
//
//}
