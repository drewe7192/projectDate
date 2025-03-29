//
//  ProfileViewModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/1/23.
//

import Foundation
import Firebase
import FirebaseStorage

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var userProfile: ProfileModel = emptyProfileModel
    @Published var isNewUser: Bool = false
    @Published var activeUsers: [ProfileModel] = []
    @Published var profileImage: UIImage = UIImage()
    
    private let profileService = ProfileService()
    let storage = Storage.storage()
    
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
        try await profileService.UpdateActivityStatus(profileId: userProfile.id, isActive: isActive)
    }
}
