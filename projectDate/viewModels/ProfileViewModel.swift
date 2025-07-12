//
//  ProfileViewModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/1/23.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFunctions
import SwiftUICore

@MainActor
class ProfileViewModel: NSObject, ObservableObject {
    @Environment(\.scenePhase) var scenePhase
    
    @Published var userProfile: ProfileModel = emptyProfileModel
    @Published var participantProfile: ProfileModel =  emptyProfileModel
    @Published var isNewUser: Bool = false
    @Published var currentUsers: [ProfileModel] = []
    
    private let profileService = ProfileService()
    private let fcmService = FCMService()
    
    let storage = Storage.storage()
    let functions = Functions.functions()
    
    public func GetUserProfile() async throws {
        let userProfile = try await profileService.GetProfile(userId: Auth.auth().currentUser?.uid ?? "")
        if(!userProfile.id.isEmpty) {
            self.userProfile = userProfile
        } else {
            if isNewUser {
                try await CreateUserProfile()
            }
        }
    }
    
    public func CreateUserProfile() async throws {
        let  createdProfile = try await profileService.CreateProfile()
        
        if(createdProfile.id != "") {
            self.userProfile = createdProfile
        }
    }
    
    public func GetCurrentUsers() async throws {
        let currentUsers = try await profileService.GetCurrentUsers(userId: Auth.auth().currentUser?.uid ?? "")
        self.currentUsers = currentUsers

        if(!self.currentUsers.isEmpty) {
            for currentUser in self.currentUsers {
                try await getFileFromStorage(profileId: currentUser.id, isActiveUser: true)
            }
            print("\(self.currentUsers[0].profileImage.size.height)")
          
        }
    }
    
    public func UpdateActivityStatus(isActive: Bool) async throws {
        try await profileService.UpdateActivityStatus(profileId: !userProfile.id.isEmpty ? userProfile.id : "XMIsmq29yPr0AKWQNB9h", isActive: isActive)
    }
    
    public func GetFCMToken(userId: String) async throws -> FCMTokenModel {
        let fcmToken = try await fcmService.GetFCMToken(userId: userId)
        return fcmToken
    }
    
    func callSendRequestNotification(fcmToken: FCMTokenModel, requestByProfile: ProfileModel) async throws -> Bool {
        do {
            /// Used for testing
            //functions.useEmulator(withHost: "localhost", port: 5001)
            
            let payload = [
                "fcmToken": fcmToken.token,
                "requestByProfileId": requestByProfile.id,
                "requestByProfileName": requestByProfile.name,
                "requestByProfileGender": requestByProfile.gender,
                "requestByProfileRoomCode": requestByProfile.roomCode,
                "requestByProfileUserId": requestByProfile.userId,
            ]
            
            let result = try await functions.httpsCallable("sendRequestNotification").call(payload)
            
            // Parse the response to extract the bool message
            if let data = result.data as? [String: Any],
               let message = data["success"] as? Bool {
                return message
            } else {
                throw NSError(domain: "InvalidResponse", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected response format."])
            }
        } catch {
            throw error
        }
    }
    
    func callSendAcceptNotification(fcmToken: FCMTokenModel) async throws -> String {
        do {
            /// Used for testing
            //functions.useEmulator(withHost: "localhost", port: 5001)
            
            let payload = [
                "fcmToken": fcmToken.token,
                "isRequestAccepted": "true",
            ]
            
            let result = try await functions.httpsCallable("sendAcceptNotification").call(payload)
            
            // Parse the response to extract the string message
            //            if let data = result.data as? [String: Any],
            //               let message = data["message"] as? String {
            //                return message
            //            } else {
            //                throw NSError(domain: "InvalidResponse", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected response format."])
            //            }
            //        } catch {
            //            throw error
            //        }
            return ""
        }
        
    }
    
    func callSendDeclineNotification(fcmToken: FCMTokenModel) async throws -> String {
        do {
            /// Used for testing
            //functions.useEmulator(withHost: "localhost", port: 5001)
            
            let payload = [
                "fcmToken": fcmToken.token,
                "isRequestAccepted": "false",
            ]
            
            let result = try await functions.httpsCallable("sendDeclineNotification").call(payload)
            
            // Parse the response to extract the bool message
            //            if let data = result.data as? [String: Any],
            //               let message = data["success"] as? Bool {
            //                return message
            //            } else {
            //                throw NSError(domain: "InvalidResponse", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected response format."])
            //            }
            //        } catch {
            //            throw error
            //        }
            return ""
        }
    }
    
    func getFileFromStorage(profileId: String, isActiveUser: Bool = false) async throws {
        let ref = storage.reference().child("\(profileId)/images/image.jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error getting file from storage: \(error)")
            } else {
                if isActiveUser {
                    if let i = self.currentUsers.firstIndex(where: {$0.id == profileId}) {
                        self.currentUsers[i].profileImage = UIImage(data: data!) ?? UIImage()
                        
                    }
                } else {
                    self.userProfile.profileImage = UIImage(data: data!) ?? UIImage()
                }
            }
        }
    }
}

///TODO:  can we put this in a more appropiate class?
extension ProfileViewModel: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        if scenePhase == .active  {
            return [[]]
        }
        return [[.sound, .banner, .badge]]
    }
}
