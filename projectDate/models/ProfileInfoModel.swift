//
//  ProfileInfoModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/1/23.
//

import Foundation

struct ProfileInfoModel: Identifiable {
    let id = UUID().uuidString
    var aboutMe: String
    var interests: String
    var height: String
}
