//
//  SpeedMeetViewModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 7/9/23.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

@MainActor
class EventViewModel: NSObject, ObservableObject {
    let db = Firestore.firestore()
    
    @Published var event: EventModel = emptyEventModel
    private let eventService = EventService()
    
    public func GetEvent(eventId: String) async throws {
        let event = try await eventService.GetEvent(eventId: eventId)
        self.event = event
    }
}
