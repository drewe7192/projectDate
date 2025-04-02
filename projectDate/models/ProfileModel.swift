//
//  Profile.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/29/22.
//

import Foundation
import SwiftUI

struct ProfileModel: Identifiable, Equatable {
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

var mockActiveUsers = [
    ProfileModel(
        id: "1",
        name: "test1",
        gender: "",
        roomCode: "grtgrt",
        isActive: true,
        profileImage: UIImage()
    ),
    ProfileModel(
        id: "2",
        name: "test2",
        gender: "",
        roomCode: "grrgrtg",
        isActive: true,
        profileImage: UIImage()
    ),
    ProfileModel(
        id: "3",
        name: "test3",
        gender: "",
        roomCode: "fdsfds",
        isActive: true,
        profileImage: UIImage()
    )
]
