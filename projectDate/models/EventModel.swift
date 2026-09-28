//
//  EventModel.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 9/28/26.
//

import Foundation

struct EventModel: Identifiable, Equatable, Codable, Hashable {
    var id: String
    var type: String
    var createdDate: Date
    var description: String
    var guestRoomCode: String
    var hostRoomCode: String
    var startDate: Date
    var title: String
    var participantProfileIds: [String]
}

var emptyEventModel = EventModel(id: "", type: "SpeedDate", createdDate: Date.now, description: "", guestRoomCode: "", hostRoomCode: "", startDate: Date.now,title: "", participantProfileIds: [])
