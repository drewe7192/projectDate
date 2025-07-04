//
//  ProfileRepository.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 2/23/25.
//

import Foundation
import Firebase

class ProfileRepository {
    let db = Firestore.firestore()
    
    public func Get(userId: String) async throws -> ProfileModel {
        var profile = emptyProfileModel
        let snapshot = try await db.collection("profiles")
            .whereField("userId", isEqualTo: userId as String)
            .getDocuments()
        
        snapshot.documents.forEach { documentSnapshot in
            let documentData = documentSnapshot.data()
            
            profile.id = documentData["id"] as! String
            profile.name = documentData["name"] as! String
            profile.gender = documentData["gender"] as! String
            profile.roomCode = documentData["roomCode"] as! String
            profile.isActive = documentData["isActive"] as! Bool
        }
        return profile
    }
    
    public func Create(newID: String, newProfile: [String: Any]) async throws {
        let docRef = db.collection("profiles").document(newID)
        try await docRef.setData(newProfile)
    }
    
    public func GetAll(userId: String) async throws -> [ProfileModel] {
        var activeProfiles: [ProfileModel] = []
        let snapshot = try await db.collection("profiles")
            .whereField("userId", isNotEqualTo: userId as String)
            .getDocuments()
        
        snapshot.documents.forEach { documentSnapshot in
            let documentData = documentSnapshot.data()
            var profile: ProfileModel = emptyProfileModel
            
            profile.id = documentData["id"] as! String
            profile.name = documentData["name"] as! String
            profile.gender = documentData["gender"] as! String
            profile.roomCode = documentData["roomCode"] as! String
            profile.isActive = documentData["isActive"] as! Bool
            profile.userId = documentData["userId"] as! String
            
            activeProfiles.append(profile)
        }
        return activeProfiles
    }
    
    public func UpdateActiveStatus(profileId: String, isActive: Bool)  async throws {
        let docRef = db.collection("profiles").document(profileId)
        try await docRef.updateData([
            "isActive": isActive
        ])
    }
}

