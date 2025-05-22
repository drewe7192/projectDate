//
//  fcmTokenModel.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 5/21/25.
//

import Foundation

struct FCMTokenModel: Identifiable, Equatable {
    var id: String
    var token: String
}

var emptyFCMTokenModel = FCMTokenModel(
    id: "",
    token: ""
)
