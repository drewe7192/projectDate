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
            name: Auth.auth().currentUser?.displayName ?? "",
            gender: "",
            roomCode: newRoomCode,
            isHost: false,
            eventId: "",
            userUID: Auth.auth().currentUser?.uid ?? "",
            profileImage: UIImage(),
        )
        
        let docData: [String: Any] = [
            "id": newProfile.id,
            "name": newProfile.name,
            "gender": newProfile.gender,
            "roomCode": newProfile.roomCode,
            "isHost": newProfile.isHost,
            "eventId": newProfile.eventId,
            "userUID": Auth.auth().currentUser?.uid as Any
        ]
        
        try await profileRepo.Create(newID: newProfile.id, newProfile: docData)
        return newProfile
    }
    
    public func GetCurrentUsers(userUID: String) async throws -> [ProfileModel] {
        let responseActiveProfiles = try await profileRepo.GetAll(userUID: userUID)
        let results = responseActiveProfiles
        
        return results
    }
    
    public func UpdateActivityStatus(profileId: String, isActive: Bool) async throws {
        try await profileRepo.UpdateActiveStatus(profileId: profileId, isActive: isActive)
    }
}
