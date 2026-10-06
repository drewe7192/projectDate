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
    
    func joinPredeterminedRound(eventId: String, roomCode: String, hostId: String, guestId: String, currentProfileId: String) {
        // 🔑 Build the identical pairing document string identifier block
        let matchDocId = "\(eventId)_\(hostId)_\(guestId)"
        let payload: [String: Any] = [
            "eventId": eventId,
            "roomCode": roomCode,
            "hostId": hostId,
            "guestId": guestId,
            "currentProfileId": currentProfileId
        ]
        
        // 🔑 THE PERMANENT FIX: Set the room code instantly on the main queue first!
        // This ensures the view unblocks and opens the 100ms viewport right away,
        // eliminating the intermittent loading freeze entirely.
        DispatchQueue.main.async {
            withAnimation {
                if self.roomCode != roomCode {
                    self.roomCode = roomCode
                }
            }
        }
        
        // 1. Trigger the backend v2 Cloud Function to initialize the session document
        functions.httpsCallable("joinSpeedDateRound").call(payload) { [weak self] _, error in
            guard let self = self else { return }
            if let error = error {
                print("🚨 Cloud Function Error: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func clearActiveRoom() {
        DispatchQueue.main.async {
            withAnimation {
                // Setting this back to empty string forces SwiftUI to safely
                // unmount the unmodifiable 100ms viewport structure completely
                self.roomCode = ""
            }
        }
    }

}
