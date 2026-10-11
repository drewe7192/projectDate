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
    
    public func Get(userUID: String) async throws -> ProfileModel {
        var profile = emptyProfileModel
        let snapshot = try await db.collection("profiles")
            .whereField("userUID", isEqualTo: userUID as String)
            .getDocuments()
        
        snapshot.documents.forEach { documentSnapshot in
            let documentData = documentSnapshot.data()
            
            profile.id = documentData["id"] as! String
            profile.userUID = documentData["userUID"] as! String
            profile.roomCode = documentData["roomCode"] as! String
            profile.name = documentData["name"] as! String
            profile.gender = documentData["gender"] as! String
            profile.bio = documentData["bio"] as? String ?? ""
        }
        return profile
    }
    
    public func Get(profileId: String) async throws -> ProfileModel {
        
        var profile = emptyProfileModel
        let snapshot = try await db.collection("profiles")
            .whereField("id", isEqualTo: profileId as String)
            .getDocuments()
        
        snapshot.documents.forEach { documentSnapshot in
            let documentData = documentSnapshot.data()
            
            profile.id = documentData["id"] as! String
            profile.userUID = documentData["userUID"] as! String
            profile.roomCode = documentData["roomCode"] as! String
            profile.name = documentData["name"] as! String
            profile.gender = documentData["gender"] as! String
            profile.bio = documentData["bio"] as? String ?? ""
        }
        return profile
    }
    
    public func Get(profileIds: [String]) async throws -> [ProfileModel] {
        guard !profileIds.isEmpty else { return [] }
        
        var activeProfiles: [ProfileModel] = []
        let snapshot = try await db.collection("profiles")
            .whereField("id", in: profileIds)
            .getDocuments()
        
        snapshot.documents.forEach { documentSnapshot in
            let documentData = documentSnapshot.data()
            var profile: ProfileModel = emptyProfileModel
            
            profile.id = documentData["id"] as! String
            profile.userUID = documentData["userUID"] as! String
            profile.roomCode = documentData["roomCode"] as! String
            profile.name = documentData["name"] as! String
            profile.gender = documentData["gender"] as! String
            profile.bio = documentData["bio"] as? String ?? ""
            
            activeProfiles.append(profile)
        }
        return activeProfiles
    }
    
    public func Create(newID: String, newProfile: [String: Any]) async throws {
        let docRef = db.collection("profiles").document(newID)
        try await docRef.setData(newProfile)
    }
    
    public func GetAll(userUID: String) async throws -> [ProfileModel] {
        var activeProfiles: [ProfileModel] = []
        let snapshot = try await db.collection("profiles")
            .whereField("userUID", isNotEqualTo: userUID as String)
            .getDocuments()
        
        snapshot.documents.forEach { documentSnapshot in
            let documentData = documentSnapshot.data()
            var profile: ProfileModel = emptyProfileModel
            
            profile.id = documentData["id"] as! String
            profile.userUID = documentData["userUID"] as! String
            profile.roomCode = documentData["roomCode"] as! String
            profile.name = documentData["name"] as! String
            profile.gender = documentData["gender"] as! String
            profile.bio = documentData["bio"] as? String ?? ""
            
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

