//
//  AppDelegate.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 5/19/25.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseCore
import FirebaseMessaging
import SwiftUICore

class AppDelegate: UIResponder, UIApplicationDelegate, ObservableObject {
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    @Published var requestByProfile: ProfileModel = emptyProfileModel
    @Published var isRequestAccepted: String = ""
    @Published var hostAnswerBlindDate: String = ""
    @Published var guestAnswerBlindDate: String = ""
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication
                        .LaunchOptionsKey: Any]?) -> Bool {
                            FirebaseApp.configure()
                            
                            Messaging.messaging().delegate = self
                            
                            // Register for remote notifications. This shows a permission dialog on first run, to
                            // show the dialog at a more appropriate time move this registration accordingly.
                            UNUserNotificationCenter.current().delegate = self
                            
                            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                            UNUserNotificationCenter.current().requestAuthorization(
                                options: authOptions,
                                completionHandler: { _, _ in }
                            )
                            
                            application.registerForRemoteNotifications()
                            
                            return true
                        }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
    -> UIBackgroundFetchResult {
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        return UIBackgroundFetchResult.newData
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // Only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        if userInfo["requestByProfileId"] is NSString {
            setRequestByProfile(userInfo: userInfo)
            return [[]]
        }
        
        if let isRequestAccepted = userInfo["isRequestAccepted"] as? NSString {
            if isRequestAccepted == "true" {
                self.isRequestAccepted = "true"
                
            } else if isRequestAccepted == "false" {
                self.isRequestAccepted = "false"
            }
            
            return [[]]
        }
        
        
        if let hostAnswerBlindDate = userInfo["hostAnswer"] as? NSString {
            self.hostAnswerBlindDate = hostAnswerBlindDate as String
        }
        
        if let guestAnswerBlindDate = userInfo["guestAnswer"] as? NSString {
            self.guestAnswerBlindDate = guestAnswerBlindDate as String
        }
        
        return [[.sound, .banner, .badge]]
    }
    
    /// this fires onTap of apple notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if userInfo["requestByProfileId"] is NSString {
            setRequestByProfile(userInfo: userInfo)
        }
        
        if let isRequestAccepted = userInfo["isRequestAccepted"] as? NSString {
            if isRequestAccepted == "true" {
                self.isRequestAccepted = "true"
                
            } else if isRequestAccepted == "false" {
                self.isRequestAccepted = "false"
            }
        }
    }
    
    func setRequestByProfile(userInfo: [AnyHashable: Any]){
        // Get message from userInfo object
        var profileDTO: ProfileModel = emptyProfileModel
        
        if let requestByProfileId = userInfo["requestByProfileId"] as? NSString {
            profileDTO.id = requestByProfileId as String
        }
        
        if let requestByProfileName = userInfo["requestByProfileName"] as? NSString {
            profileDTO.name = requestByProfileName as String
        }
        
        if let requestByProfileGender = userInfo["requestByProfileGender"] as? NSString {
            profileDTO.gender = requestByProfileGender as String
        }
        
        if let requestByProfileRoomCode = userInfo["requestByProfileRoomCode"] as? NSString {
            profileDTO.roomCode = requestByProfileRoomCode as String
        }
        
        if let requestByProfileUserId = userInfo["requestByProfileUserId"] as? NSString {
            profileDTO.userId = requestByProfileUserId as String
            
            self.requestByProfile = profileDTO
        }
    }
}

extension AppDelegate: MessagingDelegate {
    // This callback is fired at each app startup and whenever a new token is generated.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = [
            "id" : UUID().uuidString,
            "token": fcmToken ?? "",
            "userId": Auth.auth().currentUser?.uid ?? ""
        ]
        
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        
        if (dataDict["userId"] != "") {
            let db = Firestore.firestore()
            
            let docRef = db.collection("fcmTokens").document(dataDict["userId"]!)
            docRef.setData(dataDict)
        }
    }
}
