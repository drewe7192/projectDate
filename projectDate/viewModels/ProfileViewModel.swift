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

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var userProfile: ProfileModel = emptyProfileModel
    @Published var isNewUser: Bool = false
    @Published var activeUsers: [ProfileModel] = []
    @Published var profileImage: UIImage = UIImage()
    
    private let profileService = ProfileService()
    private let fcmService = FCMService()
    
    let storage = Storage.storage()
    let functions = Functions.functions()
    
    public func GetUserProfile() async throws {
        let userProfile = try await profileService.GetProfile(userId: Auth.auth().currentUser?.uid ?? "")
        if(userProfile.id != "") {
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
    
    public func GetActiveUsers() async throws {
        let activeUsers = try await profileService.GetActiveUsers(userId: Auth.auth().currentUser?.uid ?? "")
        
        if(!activeUsers.isEmpty) {
            self.activeUsers = activeUsers
        }
    }
    
    public func UpdateActivityStatus(isActive: Bool) async throws {
        try await profileService.UpdateActivityStatus(profileId: !userProfile.id.isEmpty ? userProfile.id : "XMIsmq29yPr0AKWQNB9h", isActive: isActive)
    }
    
    public func GetFCMToken(userId: String) async throws -> FCMTokenModel {
        let fcmToken = try await fcmService.GetFCMToken(userId: userId)
        return fcmToken
    }
    
    func callSendNotification(fcmToken: FCMTokenModel) async throws -> String {
        do {
            /// Used for testing
            //functions.useEmulator(withHost: "localhost", port: 5001)
            
            let payload = [
                "fcmToken": fcmToken.token
            ]
            let result = try await functions.httpsCallable("sendNotification").call(payload)
            
            // Parse the response to extract the string message
            if let data = result.data as? [String: Any],
               let message = data["message"] as? String {
                return message
            } else {
                throw NSError(domain: "InvalidResponse", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected response format."])
            }
        } catch {
            throw error
        }
    }
}
