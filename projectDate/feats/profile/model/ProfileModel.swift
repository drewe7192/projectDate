//
//  Profile.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/29/22.
//

import Foundation

struct ProfileModel: Codable, Identifiable, Hashable  {
    var id : String
    var fullName: String
    var location: String
    var gender: String
//    var image: String
//    var userId: String
}
