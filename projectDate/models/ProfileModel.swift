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
    var name: String
    var gender: String
    var roomCode: String
    var isHost: Bool
    var eventId: String
    var userUID: String
    var profileImage: UIImage
    var bio: String?
}

var emptyProfileModel = ProfileModel(
    id: "",
    name: "",
    gender: "",
    roomCode: "",
    isHost: false,
    eventId: "",
    userUID: "",
    profileImage: UIImage(),
    bio: ""
)

var mockProfiles: [ProfileModel] = [
    ProfileModel(
        id: UUID().uuidString,
        name: "Alice Johnson",
        gender: "Female",
        roomCode: "X1A2B",
        isHost: false,
        eventId: "133",
        userUID: "alice01",
        profileImage: UIImage(systemName: "person.circle.fill") ?? UIImage(),
        bio: "Coffee lover ☕ | Bookworm 📚 | Always up for deep conversations."
    ),
    ProfileModel(
        id: UUID().uuidString,
        name: "Brian Smith",
        gender: "Male",
        roomCode: "Y7C9D",
        isHost: false,
        eventId: "",
        userUID: "brian02",
        profileImage: UIImage(systemName: "person.circle") ?? UIImage(),
        bio: "Tech enthusiast 💻 | Basketball fan 🏀 | Exploring new cities 🌎."
    )
]
