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
    var isActive: Bool
    var profileImage: UIImage
    var userId: String
    var bio: String?
}

var emptyProfileModel = ProfileModel(
    id: "",
    name: "",
    gender: "",
    roomCode: "",
    isActive: false,
    profileImage: UIImage(),
    userId: "",
    bio: ""
)

var mockProfiles: [ProfileModel] = [
    ProfileModel(
        id: UUID().uuidString,
        name: "Alice Johnson",
        gender: "Female",
        roomCode: "X1A2B",
        isActive: false,
        profileImage: UIImage(systemName: "person.circle.fill") ?? UIImage(),
        userId: "alice01",
        bio: "Coffee lover ☕ | Bookworm 📚 | Always up for deep conversations."
    ),
    ProfileModel(
        id: UUID().uuidString,
        name: "Brian Smith",
        gender: "Male",
        roomCode: "Y7C9D",
        isActive: true,
        profileImage: UIImage(systemName: "person.circle") ?? UIImage(),
        userId: "brian02",
        bio: "Tech enthusiast 💻 | Basketball fan 🏀 | Exploring new cities 🌎."
    ),
    ProfileModel(
        id: UUID().uuidString,
        name: "Chloe Martinez",
        gender: "Female",
        roomCode: "Z5E4F",
        isActive: false,
        profileImage: UIImage(systemName: "star.circle.fill") ?? UIImage(),
        userId: "chloe03",
        bio: "Creative soul 🎨 | Music is my therapy 🎶 | Dog mom 🐶."
    ),
    ProfileModel(
        id: UUID().uuidString,
        name: "David Lee",
        gender: "Male",
        roomCode: "K3L8M",
        isActive: true,
        profileImage: UIImage(systemName: "flame.circle.fill") ?? UIImage(),
        userId: "david04",
        bio: "Foodie 🍜 | Hiking adventures ⛰ | Always down for game nights 🎲."
    ),
    ProfileModel(
        id: UUID().uuidString,
        name: "Ella Brown",
        gender: "Female",
        roomCode: "Q2W9R",
        isActive: false,
        profileImage: UIImage(systemName: "moon.circle.fill") ?? UIImage(),
        userId: "ella05",
        bio: "Night owl 🌙 | Aspiring photographer 📸 | Tea over coffee 🍵."
    )
]

