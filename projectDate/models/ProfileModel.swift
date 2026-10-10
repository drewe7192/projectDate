//
//  Profile.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/29/22.
//

import Foundation
import SwiftUI
import UIKit

struct ProfileModel: Identifiable, Equatable {
    var id : String
    var userUID: String
    var roomCode: String
    var name: String
    var gender: String
    var profileImage: UIImage
    var bio: String?
}

var emptyProfileModel = ProfileModel(
    id: "",
    userUID: "",
    roomCode: "",
    name: "",
    gender: "",
    profileImage: UIImage(),
    bio: ""
)
