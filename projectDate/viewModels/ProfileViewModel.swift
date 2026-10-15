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
import SwiftUI

@MainActor
class ProfileViewModel: NSObject, ObservableObject {
    @Environment(\.scenePhase) var scenePhase
    
    @Published var userProfile: ProfileModel = emptyProfileModel
    @Published var guestProfile: ProfileModel =  emptyProfileModel
    @Published var guestProfiles: [ProfileModel] =  []
    @Published var currentUsers: [ProfileModel] = []
    @Published var showingQuestionSelectSheet: Bool = false
    @Published var newRoomCode: String?
    
    private let profileService = ProfileService()
    private let fcmService = FCMService()
    
    let storage = Storage.storage()
    let functions = Functions.functions()
    var tokenToUse =  FCMTokenModel(id: "", token: "")
    
    
    public func getUserProfile() async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("⚠️ No logged in user, skipping GetUserProfile")
            return
        }
        
        let userProfile = try await profileService.getProfile(userUID: uid)
        if !userProfile.id.isEmpty {
            self.userProfile = userProfile
        } else {
            try await createUserProfile()
        }
    }
    
    public func getProfile(profileId: String) async throws {
        let profile = try await profileService.getProfile(profileId: profileId)
        if !profile.id.isEmpty {
            self.guestProfile = profile
        }
    }
    
    public func getProfiles(profileIds: [String]) async throws {
        let profiles = try await profileService.getProfiles(profileIds: profileIds)
        if !profiles.isEmpty {
            self.guestProfiles = profiles
        }
    }
    
    public func createUserProfile() async throws {
        let newRoomCode = try await handleRoomCreation()
        let  createdProfile = try await profileService.createProfile(newRoomCode: newRoomCode)
        if(!createdProfile.id.isEmpty) {
            self.userProfile = createdProfile
        }
    }
    
    func handleRoomCreation() async throws -> String {
        let functions = Functions.functions()
        let result = try await functions.httpsCallable("createRoom").call()
        
        guard let responseData = result.data as? [String: Any],
              let roomCode = responseData["roomCode"] as? String else {
            throw NSError(domain: "FunctionsError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from Cloud Function"])
        }
        return roomCode
    }
    
    public func updateActivityStatus(isActive: Bool) async throws {
        try await profileService.updateActivityStatus(profileId: !userProfile.id.isEmpty ? userProfile.id : "XMIsmq29yPr0AKWQNB9h", isActive: isActive)
    }
    
    public func getFCMToken(userId: String) async throws -> FCMTokenModel {
        let fcmToken = try await fcmService.getFCMToken(userId: userId)
        return fcmToken
    }
    
    func callSendRequestNotification(fcmToken: FCMTokenModel, requestByProfile: ProfileModel) async throws -> Bool {
        do {
            /// Used for testing
            //functions.useEmulator(withHost: "localhost", port: 5001)

            if fcmToken.id.isEmpty {
                tokenToUse = FCMTokenModel(id: fcmToken.id, token: "fake_token_123456") // fill other properties if needed
            } else {
                tokenToUse = fcmToken
            }

            
            let payload = [
                "fcmToken": tokenToUse.token,
                "requestByProfileId": requestByProfile.id,
                "requestByProfileName": requestByProfile.name,
                "requestByProfileGender": requestByProfile.gender,
                "requestByProfileRoomCode": requestByProfile.roomCode,
                "requestByProfileUserId": requestByProfile.userUID,
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
            
            _ = try await functions.httpsCallable("sendAcceptNotification").call(payload)
            

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
            
            _ = try await functions.httpsCallable("sendDeclineNotification").call(payload)
            
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
    
    func callCreateRoomFunction() async throws -> String  {
        let functions = Functions.functions()
        
        let result = try await functions.httpsCallable("createRoom").call()
        
        guard let responseData = result.data as? [String: Any],
              let roomCode = responseData["roomCode"] as? String else {
            throw NSError(domain: "FunctionsError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid respone from Cloud Function"])
        }
        
        return roomCode
    }
}
