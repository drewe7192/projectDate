//
//  VideoViewModel.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 3/29/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class VideoViewModel: ObservableObject {
    // 🔑 Placed all reactive layout properties inside the localized video model
    @Published var timeRemainingString: String = "03:00"
    @Published var isTimeRunningOut: Bool = false
    @Published var roundEndTime: Date? = nil
    @Published var isRoundActive: Bool = false
    
    private var db = Firestore.firestore()
    private var dateListener: ListenerRegistration?
    private var timer: Timer?
    private var localSecondsRemaining: Int = 180
    
    /// Attaches the live listener to your event match doc directly
    func listenToMatchSession(eventId: String, hostId: String, guestId: String) {
        let matchDocId = "\(eventId)_\(hostId)_\(guestId)"
        
        dateListener = db.collection("activeDates").document(matchDocId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                guard let snapshot = snapshot, snapshot.exists, let data = snapshot.data() else { return }
                
                
                
                
                
                
                
                
                if snapshot.metadata.isFromCache {
                         print("⏳ Skipping cached data... waiting for live server state.")
                         return
                     }
                
                
                
                
                // 1. Check absolute server target countdown expiration
                if let timestamp = data["roundEndsAt"] as? Timestamp {
                    let serverDate = timestamp.dateValue()
                    if self.roundEndTime != serverDate {
                        DispatchQueue.main.async {
                            self.roundEndTime = serverDate
                        }
                    }
                }
                
                // 2. Manage the countdown gate state via server status
                if let status = data["status"] as? String {
                    DispatchQueue.main.async {
                        let activeState = (status == "active")
                        if self.isRoundActive != activeState {
                            self.isRoundActive = activeState
                            if activeState, let targetTime = self.roundEndTime {
                                self.startCountdown(targetEndTime: targetTime)
                            }
                        }
                        
                        if status == "completed" {
                            self.stopMatchSession()
                        }
                    }
                }
            }
    }
    
    private func startCountdown(targetEndTime: Date) {
        timer?.invalidate()
        
        let initialSecondsLeft = Int(targetEndTime.timeIntervalSinceNow)
        self.localSecondsRemaining = initialSecondsLeft > 0 ? initialSecondsLeft : 180
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.localSecondsRemaining <= 0 {
                self.timer?.invalidate()
                DispatchQueue.main.async {
                    self.timeRemainingString = "00:00"
                    self.isTimeRunningOut = true
                }
            } else {
                self.localSecondsRemaining -= 1
                let minutes = self.localSecondsRemaining / 60
                let seconds = self.localSecondsRemaining % 60
                
                DispatchQueue.main.async {
                    self.timeRemainingString = String(format: "%02d:%02d", minutes, seconds)
                    self.isTimeRunningOut = self.localSecondsRemaining <= 15
                }
            }
        }
    }
    
    func stopMatchSession() {
        timer?.invalidate()
        timer = nil
        dateListener?.remove()
    }
    
    deinit {
        timer?.invalidate()
        dateListener?.remove()
    }
    
    func endRoundCleanly() {
        // 1. Invalidate and clear the timer thread securely
        timer?.invalidate()
        timer = nil
        
        // 2. Remove the Firestore real-time snapshot listener
        dateListener?.remove()
        dateListener = nil
        
        // 3. Clear all published UI layout variables safely on the Main thread
        DispatchQueue.main.async {
            self.timeRemainingString = "03:00"
            self.isTimeRunningOut = false
            self.roundEndTime = nil
            self.isRoundActive = false
        }
    }

    
}

