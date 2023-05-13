//
//  speedDateModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 4/4/23.
//

import Foundation

struct SpeedDateModel: Identifiable, Codable, Hashable{
    var id: String
    var roomId: String
    var matchProfileIds: [String]
    var eventDate: Date
    var createdDate: Date
    var isActive: Bool
}
