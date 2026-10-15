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
    
    public func getEvent(eventId: String) async throws -> EventModel {
        let response = try await eventRepo.get(eventId: eventId)
        return response
    }
    
    public func getEvent(profileId: String) async throws -> EventModel {
        let response = try await eventRepo.get(profileId: profileId)
        return response
    }
}

