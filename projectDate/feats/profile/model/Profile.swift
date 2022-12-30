//
//  Profile.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/29/22.
//

import Foundation

struct Profile: Identifiable {
    var id = UUID().uuidString
    var firstName: String
    var lastName: String
    var location: String
    
    var fullName: String {
        lastName + ", " + firstName
    }
}
