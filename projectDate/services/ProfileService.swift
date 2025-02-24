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
        let responseProfile = try await profileRepo.Get(userId: userId)
        var result = responseProfile
        
        return result
    }
    
    public func CreateProfile() async throws -> ProfileModel {
        let id = UUID().uuidString
        let newProfile = ProfileModel(
            id: id,
            name: Auth.auth().currentUser?.displayName ?? "",
            gender: "",
            roomCode: "",
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
}
