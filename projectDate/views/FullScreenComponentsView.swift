//
//  SwiftUIView.swift
//  HMSRoomKit
//
//  Created by DotZ3R0 on 4/20/25.
//

import SwiftUI
import Firebase
import HMSRoomModels


import SwiftUI
import FirebaseFirestore
import FirebaseCore

struct FullScreenComponentsView: View {
    @EnvironmentObject var videoVM: VideoViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @Environment(\.scenePhase) var scenePhase // 🔑 Layer 2: Detects if the app is minimized/backgrounded
    
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
            
            // MARK: - ACTION BUTTON LAYOUT
            HStack(spacing: 16) {
                // 🔑 Layer 1: The explicit physical Leave Match Button (Available for the Guest)
                if role == .guest {
                    Button(action: {
                        executeGuestLeaveAction()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "phone.down.fill")
                                .font(.subheadline)
                            Text("Leave Match")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(Color.orange.opacity(0.85))
                        .cornerRadius(14)
                        .shadow(radius: 6)
                    }
                }
                
                // Block & Report Button (Available to both Host and Guest)
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
            }
            .padding(.bottom, 40)
        }
        // MARK: - BACKGROUND SCENE PHASE DETECTOR
        .onChange(of: scenePhase) { newPhase in
            // If the guest device minimizes the app to check messages/home screen, drop them automatically
            if newPhase == .background {
                print("📱 Guest device backgrounded app. Dropping session state.")
                executeGuestLeaveAction()
            }
        }
        .onAppear {
            // Kick off your Firestore data listener right when the overlay mounts
            videoVM.listenToMatchSession(eventId: eventId, hostId: hostId, guestId: guestId)
        }
        .onDisappear {
            videoVM.stopMatchSession()
        }
    }
    
    // MARK: - REUSABLE GUEST EXIT HANDLER
    private func executeGuestLeaveAction() {
        print("🧹 Cleaning up call variables and updating database status values...")
        
        // Kill the local audio/video hardware pipelines and listeners
        videoVM.endRoundCleanly()
        
        let db = Firestore.firestore()
        let matchDocId = "\(eventId)_\(hostId)"
        
        // Write the state reset straight to Firestore
        db.collection("activeDates").document(matchDocId).updateData([
            "status": "completed",
            "guestId": "",
            "roundEndTime": FieldValue.delete()
        ]) { error in
            if let error = error {
                print("❌ Manual exit database write failed: \(error.localizedDescription)")
            } else {
                print("✅ Manual exit database write succeeded.")
                DispatchQueue.main.async {
                    viewRouter.currentPage = .speedDateLobby
                }
            }
        }
    }
    
    // MARK: - BLOCK & REPORT PIPELINE
    private func executeBlockAndReportAction() {
        print("🚨 Block & Report tapped. Evicting hardware tracks and flag writing...")
        videoVM.endRoundCleanly()
        
        let db = Firestore.firestore()
        let matchDocId = "\(eventId)_\(hostId)"
        let targetOffenderId = (role == .host) ? guestId : hostId
        let myCurrentUserId = (role == .host) ? hostId : guestId
        
        db.collection("activeDates").document(matchDocId).updateData([
            "status": "completed",
            "terminatedBySafetyFlag": myCurrentUserId
        ]) { error in
            if let error = error {
                print("Error reporting match document entry: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    viewRouter.currentPage = .speedDateLobby
                }
            }
        }
        
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
            }
        }
    }
}
