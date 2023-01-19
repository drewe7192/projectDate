//
//  Profile.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/29/22.
//

import Foundation

struct ProfileModel: Identifiable {
    var id: Int
    var firstName: String
    var lastName: String
    var location: String
    var profileType: String
    var images: [String]
    var info: ProfileInfoModel
    var test: Int
    
    var fullName: String {
        lastName + ", " + firstName
    }
}
