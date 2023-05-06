//
//  RolesModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 5/6/23.
//

import Foundation

struct RolesModel: Decodable {
    var roles: [RoleModel] = []
    
    enum CodingKeys: String, CodingKey {
        case roles
    }
}
