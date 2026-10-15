//
//  EventRepository.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 9/28/26.
//

import Foundation
import Firebase

class EventRepository {
    let db = Firestore.firestore()
    
    public func get() async throws -> [EventModel] {
        var events: [EventModel] = []
        let snapshot = try await db.collection("events")
            .limit(to: 10)
            .getDocuments()
        
        snapshot.documents.forEach { documentSnapshot in
            let documentData = documentSnapshot.data()
            
            var event: EventModel = emptyEventModel
            event.id = documentData["id"] as! String
            event.hostProfileId = documentData["hostProfileId"] as! String
            event.participantProfileIds = documentData["participantProfileIds"] as! [String]
            event.guestRoomCode = documentData["guestRoomCode"] as! String
            event.hostRoomCode = documentData["hostRoomCode"] as! String
            event.type = documentData["type"] as! String
            
            if let createdTimestamp = documentData["createdDate"] as? Timestamp {
                event.createdDate = createdTimestamp.dateValue()
            }
            if let startTimestamp = documentData["startDate"] as? Timestamp {
                event.startDate = startTimestamp.dateValue()
            }
            
            // Safely parsing the participantOrder Map
              if let rawOrderMap = documentData["participantOrder"] as? [String: String] {
                  event.participantOrder = rawOrderMap
              } else {
                  event.participantOrder = [:] // Safe empty fallback if the map doesn't exist yet
              }
            
            events.append(event)
        }
        return events
    }
    
    public func get(eventId: String) async throws -> EventModel {
        var event: EventModel = emptyEventModel
        let snapshot = try await db.collection("events")
            .whereField("id", isEqualTo: eventId)
            .getDocuments()
        
        snapshot.documents.forEach { documentSnapshot in
            let documentData = documentSnapshot.data()
            
            event.id = documentData["id"] as! String
            event.hostProfileId = documentData["hostProfileId"] as! String
            event.participantProfileIds = documentData["participantProfileIds"] as! [String]
            event.guestRoomCode = documentData["guestRoomCode"] as! String
            event.hostRoomCode = documentData["hostRoomCode"] as! String
            event.type = documentData["type"] as! String
            
            // Safely parsing the participantOrder Map
              if let rawOrderMap = documentData["participantOrder"] as? [String: String] {
                  event.participantOrder = rawOrderMap
              } else {
                  event.participantOrder = [:] // Safe empty fallback if the map doesn't exist yet
              }
        }
        return event
    }
    
    public func get(profileId: String) async throws -> EventModel {
        var event: EventModel = emptyEventModel
        let snapshot = try await db.collection("events")
            .whereField("participantProfileIds", arrayContains: profileId)
            .getDocuments()
        
        snapshot.documents.forEach { documentSnapshot in
            let documentData = documentSnapshot.data()
            
            event.id = documentData["id"] as! String
            event.hostProfileId = documentData["hostProfileId"] as! String
            event.participantProfileIds = documentData["participantProfileIds"] as! [String]
            event.guestRoomCode = documentData["guestRoomCode"] as! String
            event.hostRoomCode = documentData["hostRoomCode"] as! String
            event.type = documentData["type"] as! String
            
            // Safely parsing the participantOrder Map without type-casting crashes
              if let rawOrderMap = documentData["participantOrder"] as? [String: String] {
                  event.participantOrder = rawOrderMap
              } else {
                  event.participantOrder = [:] // Safe empty fallback if the map doesn't exist yet
              }
        }
        return event
    }
    
    public func save(event: EventModel) async throws {
            try db.collection("events").document(event.id).setData(from: event)
    }
}
