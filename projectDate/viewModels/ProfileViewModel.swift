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
    private let profileService = ProfileService()
    let storage = Storage.storage()
    @Published var userProfile: ProfileModel = emptyProfileModel
    @Published var isNewUser: Bool = false
    
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
}
