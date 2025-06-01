//
//  VideoConfigModel.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 5/31/25.
//

import Foundation

struct VideoConfigModel {
    var role: RoleType
    var isScreenBlurred: Bool
    var isFullScreen: Bool
}

var emptyVideoConfig = VideoConfigModel(role: RoleType.host, isScreenBlurred: false, isFullScreen: false)
