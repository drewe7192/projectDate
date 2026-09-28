//
//  EventService.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 9/28/26.
//

import Foundation
import Firebase

class EventService {
    private let eventRepo = EventRepository()
    
    public func GetEvent(eventId: String) async throws -> EventModel {
        let response = try await eventRepo.Get(eventId: eventId)
        return response
    }
}

