//
//  speedDateModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 4/4/23.
//

import Foundation

struct speedDateModel: Identifiable {
    var id = UUID().uuidString
    var firstName: String
    var lastName: String
    var time: Int
    var userRoleType: String
    var roomNumber: String
    var profiles: [ProfileModel]
    
    var fullName: String {
        lastName + " " + firstName
    }
    
}
