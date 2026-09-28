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
    
    public func Get() async throws -> [EventModel] {
        var events: [EventModel] = []
        let snapshot = try await db.collection("events")
            .limit(to: 10)
            .getDocuments()
        
        snapshot.documents.forEach { documentSnapshot in
            let documentData = documentSnapshot.data()
            
            var event: EventModel = emptyEventModel
            event.id = documentData["id"] as! String
            event.type = documentData["type"] as! String
            event.guestRoomCode = documentData["guestRoomCode"] as! String
            event.hostRoomCode = documentData["hostRoomCode"] as! String
            event.participantProfileIds = documentData["participantProfileIds"] as! [String]
            
            events.append(event)
        }
        return events
    }
    
    public func Get(eventId: String) async throws -> EventModel {
        var event: EventModel = emptyEventModel
        let snapshot = try await db.collection("events")
            .whereField("id", isEqualTo: eventId)
            .getDocuments()
        
        snapshot.documents.forEach { documentSnapshot in
            let documentData = documentSnapshot.data()
            
            event.id = documentData["id"] as! String
            event.type = documentData["type"] as! String
            event.hostRoomCode = documentData["hostRoomCode"] as! String
            event.guestRoomCode = documentData["guestRoomCode"] as! String
            event.participantProfileIds = documentData["participantProfileIds"] as! [String]
        }
        return event
    }
    
    public func Save(event: EventModel) async throws {
        do {
            try db.collection("events").document(event.id).setData(from: event)
        } catch let error {
            print(error)
        }
    }
    
}
