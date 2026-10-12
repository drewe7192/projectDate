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
    @Published var timeRemainingString: String = "00:20"
    @Published var isTimeRunningOut: Bool = false
    @Published var roundEndTime: Date? = nil
    @Published var isRoundActive: Bool = false
    @Published var currentRoundNumber: Int = 1
    
    private var db = Firestore.firestore()
    private var dateListener: ListenerRegistration?
    private var timer: Timer?
    private var localSecondsRemaining: Int = 20
    
    /// Attaches the live listener to your event match doc directly
    func listenToMatchSession(eventId: String, hostId: String, guestId: String, role: RoleType, viewRouter: ViewRouter) {
        let matchDocId = "\(eventId)_\(hostId)"
        
        dateListener = db.collection("activeDates").document(matchDocId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                guard let snapshot = snapshot, snapshot.exists, let data = snapshot.data() else { return }
                
                if snapshot.metadata.isFromCache {
                    print("⏳ Skipping cached data... waiting for live server state.")
                    return
                }
                
                // 🚀 STEP A: Extract ALL parameters from the network snapshot packet SYNCHRONOUSLY first!
                var extractedServerDate: Date? = nil
                if let timestamp = data["roundEndTime"] as? Timestamp {
                    extractedServerDate = timestamp.dateValue()
                }
                
                let status = data["status"] as? String ?? ""
                let activeState = (status == "active")
                
                // 🚀 THE FIX: Safely parse and bind the server round number straight to videoVM!
                if let serverRoundNumber = data["currentRoundNumber"] as? Int {
                    DispatchQueue.main.async {
                        // Update your shared video view-model property so the entire view re-orders instantly!
                        self.currentRoundNumber = serverRoundNumber
                        print("👑 Host synchronized current round from database: \(serverRoundNumber)")
                    }
                }
                
                // 🚀 STEP B: Dispatch ONE single, combined atomic block onto the Main Actor Thread!
                DispatchQueue.main.async {
                    // 1. Commit the absolute countdown target date to memory first
                    if let verifiedDate = extractedServerDate {
                        self.roundEndTime = verifiedDate
                    }
                    
                    // 2. Commit the structural room active boundary configurations
                    if self.isRoundActive != activeState {
                        self.isRoundActive = activeState
                        
                        // 🔑 GUARANTEED SAFE: Since both assignments run inline within the same exact thread execution pass,
                        // 'self.roundEndTime' can NEVER evaluate as nil when this block evaluates!
                        if activeState, let targetTime = self.roundEndTime {
                            print("⏱️ VideoVM: Starting countdown ticker pipeline atomically for: \(targetTime)")
                            self.startCountdown(targetEndTime: targetTime, viewRouter: viewRouter, eventId: eventId, hostId: hostId, guestId: guestId, role: role)
                        }
                    }
                    
                    // 3. Handle graceful room timeout teardown conditions
                    if status == "completed" {
                        print("⏱️ VideoVM: Match completion packet received. Dropping stream layout pipelines.")
                        self.stopMatchSession()
                    }
                }
            }
    }
    
    
    private func startCountdown(targetEndTime: Date, viewRouter: ViewRouter, eventId: String, hostId: String, guestId: String, role: RoleType) {
        timer?.invalidate()
        
        let initialSecondsLeft = Int(targetEndTime.timeIntervalSinceNow)
        self.localSecondsRemaining = initialSecondsLeft > 0 ? initialSecondsLeft : 20
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.localSecondsRemaining <= 0 {
                self.timer?.invalidate()
                
                
                // This writes the new round number to Firestore, updating both apps instantly!
                self.hostAdvanceRoundOnServer(eventId: eventId, hostId: hostId, currentRoundNumber: currentRoundNumber)
                
                self.stopMatchSession()
                self.endRoundCleanly()
                
                DispatchQueue.main.async {
                    self.timeRemainingString = "00:00"
                    self.isTimeRunningOut = true
                }
                
                if case .videoPage = viewRouter.currentPage {
                    viewRouter.currentPage = .speedDateLobby
                }
                
            } else {
                self.localSecondsRemaining -= 1
                let minutes = self.localSecondsRemaining / 60
                let seconds = self.localSecondsRemaining % 60
                
                DispatchQueue.main.async {
                    self.timeRemainingString = String(format: "%02d:%02d", minutes, seconds)
                    self.isTimeRunningOut = self.localSecondsRemaining <= 10
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
            self.timeRemainingString = "00:20"
            self.isTimeRunningOut = false
            self.roundEndTime = nil
            self.isRoundActive = false
        }
    }
    
    func hostAdvanceRoundOnServer(eventId: String, hostId: String, currentRoundNumber: Int) {
        let db = Firestore.firestore()
        let matchDocId = "\(eventId)_\(hostId)"
        
        // 🔑 Read what the current round number is right before updating it
        let nextRound = currentRoundNumber + 1
        
        print("👑 Host advancing matchmaking state to Round \(nextRound) on Firestore...")
        
        // Reset parameters and advance the master server round tracking index
        db.collection("activeDates").document(matchDocId).updateData([
            "status": "completed",
            "currentRoundNumber": nextRound, // 🚀 UPDATES BOTH DEVICES SIMULTANEOUSLY!
            "guestId": "",
            "hostRoomCode": "",
            "guestRoomCode": ""
        ]) { error in
            if let error = error {
                print("❌ Failed to advance round number in Firestore: \(error.localizedDescription)")
            } else {
                print("✅ Success: Server is now configured for Round \(nextRound)")
            }
        }
    }
}

