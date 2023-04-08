//
//  Message.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/31/23.
//

import Foundation

struct MessageModel: Identifiable, Codable{
    var id: String
    var received: Bool
    var text: String
    var timeStamp: Date
}

enum CodingKeys: String, CodingKey {
    case id
    case received
    case text
    case timeStamp
}
