//
//  EventModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/21/23.
//

import Foundation


struct EventModel: Identifiable {
    var id: Int
    let title: String
    let Date: String
    let participants: [String]
}
