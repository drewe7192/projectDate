//
//  sdTimes.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/30/22.
//

import Foundation

struct sdTimeModel: Identifiable {
    var id = UUID().uuidString
    var firstName: String
    var lastName: String
    var time: Date
    var userRoleType: String
    
    var fullName: String {
        lastName + ", " + firstName
    }
    
}
