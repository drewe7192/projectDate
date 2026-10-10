//
//  ProfileService.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 2/23/25.
//

import Foundation
import Firebase

class ProfileService {
    private let profileRepo = ProfileRepository()
    private let fcmTokenRepo = FCMTokenRepository()
    
    public func GetProfile(userUID: String) async throws -> ProfileModel {
        let response = try await profileRepo.Get(userUID: userUID)
        return response
    }
    
    public func CreateProfile(newRoomCode: String) async throws -> ProfileModel {
        guard let uid = Auth.auth().currentUser?.uid else {
              throw NSError(domain: "ProfileService", code: 401, userInfo: [NSLocalizedDescriptionKey: "No logged in user"])
          }
        
        let id = UUID().uuidString
        let newProfile = ProfileModel(
            id: id,
            userUID: Auth.auth().currentUser?.uid ?? "",
            roomCode: newRoomCode,
            name: Auth.auth().currentUser?.displayName ?? "",
            gender: "",
            profileImage: UIImage(),
            bio: ""
        )
        
        let docData: [String: Any] = [
            "id": newProfile.id,
            "userUID": Auth.auth().currentUser?.uid as Any,
            "roomCode": newProfile.roomCode,
            "name": newProfile.name,
            "gender": newProfile.gender,
            "bio": (newProfile.bio ?? "") as String
        ]
        
        try await profileRepo.Create(newID: newProfile.id, newProfile: docData)
        return newProfile
    }
    
    public func UpdateActivityStatus(profileId: String, isActive: Bool) async throws {
        try await profileRepo.UpdateActiveStatus(profileId: profileId, isActive: isActive)
    }
}
