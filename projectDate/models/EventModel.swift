//
//  EventModel.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 9/28/26.
//

import Foundation

struct EventModel: Identifiable, Equatable, Codable, Hashable {
    var id: String
    var hostProfileId: String
    var participantOrder: [String: String]
    var participantProfileIds: [String]
    var guestRoomCode: String
    var hostRoomCode: String
    var createdDate: Date
    var startDate: Date
    var type: String
}

var emptyEventModel = EventModel(id: "", hostProfileId: "", participantOrder: ["": ""], participantProfileIds: [], guestRoomCode: "", hostRoomCode: "", createdDate: Date.now, startDate: Date.now, type: "SpeedDate",)
