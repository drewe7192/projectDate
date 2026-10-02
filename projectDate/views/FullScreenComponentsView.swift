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
            // 🔑 Checks videoVM directly. Changing this will NEVER redraw the HMSPrebuiltView.
            if videoVM.isRoundActive && videoVM.roundEndTime != nil {
                Text(videoVM.timeRemainingString)
                    .font(.system(.title2, design: .monospaced))
                    .bold()
                    .foregroundColor(videoVM.isTimeRunningOut ? .red : .white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(20)
                    .padding(.top, 50)
            } else {
                Text("Waiting for date to join...")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.6))
                    .cornerRadius(20)
                    .padding(.top, 50)
            }
            Spacer()
        }
        .onAppear {
            // Kick off your Firestore data listener right when the overlay mounts
            videoVM.listenToMatchSession(eventId: eventId, hostId: hostId, guestId: guestId)
        }
        .onDisappear {
            videoVM.stopMatchSession()
        }
    }
}
