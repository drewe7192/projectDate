//
//  Message.swift
//  projectDate
//
//  Created by Drew Sutherlan on 8/7/22.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI

struct Message: Identifiable, Codable{
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
