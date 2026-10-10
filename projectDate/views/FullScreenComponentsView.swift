//
//  SwiftUIView.swift
//  HMSRoomKit
//
//  Created by DotZ3R0 on 4/20/25.
//

import SwiftUI
import Firebase
import HMSRoomModels

struct FullScreenComponentsView: View {
    // 🔑 Holds your localized timer and snapshot state safely
    @StateObject private var videoVM = VideoViewModel()
    
    let role: RoleType
    let eventId: String
    let hostId: String
    let guestId: String
    
    var body: some View {
        VStack {
            ZStack {
                if videoVM.isRoundActive && videoVM.roundEndTime != nil {
                    Text(videoVM.timeRemainingString)
                        .font(.system(.title2, design: .monospaced))
                        .bold()
                        .foregroundColor(videoVM.isTimeRunningOut ? .red : .white)
                    
                    
                } else {
                    Text("Waiting for date to join...")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.6))
            .cornerRadius(20)
            .frame(width: 240, height: 45)
            .padding(.top, 50)
            
            Spacer()
            
            
            Button(action: {
                 executeBlockAndReportAction()
             }) {
                 HStack(spacing: 8) {
                     Image(systemName: "exclamationmark.shield.fill")
                         .font(.subheadline)
                     Text("Block & Report")
                         .font(.headline)
                 }
                 .foregroundColor(.white)
                 .padding(.horizontal, 24)
                 .padding(.vertical, 14)
                 .background(Color.red.opacity(0.85))
                 .cornerRadius(14)
                 .shadow(radius: 6)
             }
             .padding(.bottom, 40)
        }
        .onAppear {
                // Kick off your Firestore data listener right when the overlay mounts
                 videoVM.listenToMatchSession(eventId: eventId, hostId: hostId, guestId: guestId)
        }
        .onDisappear {
            videoVM.stopMatchSession()
        }
    }
    
    /// 🔑 Instantly shuts down the native video pipeline and writes a safety report to your server backend
    private func executeBlockAndReportAction() {
        print("🚨 Block & Report tapped. Evicting hardware tracks and flag writing...")
        
        // 1. Terminate the local clock and detach the active Firestore date listener thread
        videoVM.endRoundCleanly()
        
        // 2. Clear out the global speedDateVM room code to instantly unmount the unmodifiable HMSPrebuiltView
        videoVM.endRoundCleanly()
        
        // 3. Write a permanent block token payload entry into your Firestore database
        let db = Firestore.firestore()
        let matchDocId = "\(eventId)_\(hostId)_\(guestId)"
        let targetOffenderId = (role == .host) ? guestId : hostId
        let myCurrentUserId = (role == .host) ? hostId : guestId
        
        // A. Flag the match document as completed due to standard safety termination violation rules
        db.collection("activeDates").document(matchDocId).updateData([
            "status": "completed",
            "terminatedBySafetyFlag": myCurrentUserId
        ]) { error in
            if let error = error {
                print("Error reporting match document entry: \(error.localizedDescription)")
            }
        }
        
        // B. Add a record inside your moderation collection so your 24-hour review protocol can ban them
        let reportData: [String: Any] = [
            "reporterId": myCurrentUserId,
            "offenderId": targetOffenderId,
            "eventId": eventId,
            "timestamp": FieldValue.serverTimestamp(),
            "status": "pending_review"
        ]
        
        db.collection("blockedUsers").addDocument(data: reportData) { error in
            if let error = error {
                print("Error submitting safety block payload: \(error.localizedDescription)")
            } else {
                print("✅ Safety incident reported successfully. Backend will review inside 24 hours.")
            }
        }
    }
}
