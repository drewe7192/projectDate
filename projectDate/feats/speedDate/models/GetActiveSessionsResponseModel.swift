//
//  ActiveSessionModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 5/23/23.
//

import Foundation

struct GetActiveSessionsResponseModel: Codable{
    var data: [ActiveSessionModel]
}

struct ActiveSessionModel: Codable{
    var id: String
    var room_id: String
    var active: Bool
    var peers: [String:PeerModel]
}
