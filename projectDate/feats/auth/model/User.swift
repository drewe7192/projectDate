//
//  User.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/30/22.
//

import Foundation

struct User: Identifiable {
    var id = UUID().uuidString
    var firstName: String
    var lastName: String
    var location: String
    var sdTimes: [sdTimeModel]
    var Profiles: [ProfileModel]
    
    
    var fullName: String {
        lastName + ", " + firstName
    }
}
