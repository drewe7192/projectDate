//
//  ProfileViewModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/1/23.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var person: ProfileModel = MockService.profileSampleData
    
    init(forPreview: Bool = false) {
        if forPreview {
            person = MockService.profileSampleData

        }
    }
    
}
