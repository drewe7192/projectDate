//
//  Profile.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/29/22.
//

import Foundation

struct ProfileModel: Codable, Identifiable  {
    var id : String
    var fullName: String
    var location: String
    var gender: String
    var matchDay: String
    var messageThreadIds: [String]
    var speedDateIds: [String]
    var fcmTokens: [String]
    var preferredGender: String
}
