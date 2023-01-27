//
//  Profile.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/29/22.
//

import Foundation

struct ProfileModel: Identifiable {
    let id = UUID().uuidString
    var firstName: String
    var lastName: String
    var location: String
    var images: [String]
    var info: ProfileInfoModel
    var cards: [CardModel]
    var topRatedProfiles: [ProfileModel?]
    var recommendedProfiles: [ProfileModel?]
    var sds: [sdModel?]
    var tabCardNumber: Int
   
    var fullName: String {
        lastName + ", " + firstName
    }
}
