//
//  Profile.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/29/22.
//

import Foundation
import SwiftUI

struct ProfileModel: Identifiable {
    var id : String
    var name: String
    var gender: String
    var roomCode: String
    var isActive: Bool
    var profileImage: UIImage
}

var emptyProfileModel = ProfileModel(
    id: "",
    name: "",
    gender: "",
    roomCode: "",
    isActive: false,
    profileImage: UIImage()
)
