//
//  MessageThreadModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 4/8/23.
//

import Foundation

struct MessageThreadModel: Codable, Identifiable {
    var id: String
    var profileId: String
    var messageIds: [String]
}
