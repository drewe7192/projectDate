//
//  Message.swift
//  projectDate
//
//  Created by Drew Sutherlan on 8/7/22.
//

import Foundation

struct Message: Identifiable, Codable{
    var id: String
    var text: String
    var receieved: Bool
    var timeStamp: Date
}
