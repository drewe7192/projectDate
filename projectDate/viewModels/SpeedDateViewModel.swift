//
//  SpeedDateViewModel.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 9/30/26.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFunctions

class SpeedDateViewModel: ObservableObject {
    // 🔑 ONLY roomCode is left here. No more timer strings or booleans!
    @Published var roomCode: String = ""
    private var functions = Functions.functions()
    
    func joinPredeterminedRound(eventId: String, roomCode: String, hostId: String, guestId: String, currentUserId: String) {
        // 🔑 Build the identical pairing document string identifier block
        let matchDocId = "\(eventId)_\(hostId)_\(guestId)"
        let payload: [String: Any] = [
            "eventId": eventId,
            "roomCode": roomCode,
            "hostId": hostId,
            "guestId": guestId
        ]
        
        // 1. Trigger the backend v2 Cloud Function to initialize the session document
        functions.httpsCallable("joinSpeedDateRound").call(payload) { [weak self] _, error in
            guard let self = self else { return }
            if let error = error {
                print("🚨 Cloud Function Error: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                withAnimation {
                    // 🔑 Populates roomCode exactly ONCE to open the screen safely
                    self.roomCode = roomCode
                }
            }
        }
    }
}
