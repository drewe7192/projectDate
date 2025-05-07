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
    
    public func GetProfile(userId: String) async throws -> ProfileModel {
        let response = try await profileRepo.Get(userId: userId)
        return response
    }
    
    public func CreateProfile() async throws -> ProfileModel {
        let id = UUID().uuidString
        let newProfile = ProfileModel(
            id: id,
            name: Auth.auth().currentUser?.displayName ?? "",
            gender: "",
            roomCode: "",
            isActive: false,
            profileImage: UIImage()
        )
        
        let docData: [String: Any] = [
            "id": newProfile.id,
            "name": newProfile.name,
            "gender": newProfile.gender,
            "roomCode": newProfile.roomCode,
            "userId": Auth.auth().currentUser?.uid as Any
        ]
        
        try await profileRepo.Create(newID: newProfile.id, newProfile: docData)
        return newProfile
    }
    
    public func GetActiveUsers(userId: String) async throws -> [ProfileModel] {
        let responseActiveProfiles = try await profileRepo.GetActive(userId: userId)
        var results = responseActiveProfiles
        
        return results
    }
    
    public func UpdateActivityStatus(profileId: String, isActive: Bool) async throws {
        try await profileRepo.UpdateActiveStatus(profileId: profileId, isActive: isActive)
    }
}
