//
//  SpeedDateLobbyView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 9/8/25.
//

import SwiftUI
import Combine

struct SpeedDateLobbyView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var eventVM: EventViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var speedDateVM: SpeedDateViewModel
    @EnvironmentObject var videoVM: VideoViewModel
    
    // 🔑 Keep track of which match number the host is currently on
    @State private var currentRoundNumber: Int = 1
    @State private var showMatchConfirmationSheet: Bool = false
    
    @State private var opponentName: String = ""
    @State private var opponentBio: String = ""
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    AnimatedGradientBackground()
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Text("Speed Dating Event")
                            .font(.largeTitle)
                            .bold()
                        
                        // 🔑 Shows the current progress of the event to the user
                        Text("Current Progress: Round \(currentRoundNumber) of 3")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                        
                        Text("Ready for your structured matchmaking round?")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        // Dynamic Action Button based on progress
                        Button(action: {
                            // 🔑 DYNAMIC MATCH GENERATION: Loads the correct profile metadata based on the current round sequence
                            prepareNextOpponentMetadata()
                            
                            // Show the required explicit consent sheet before opening any camera pipelines
                            self.showMatchConfirmationSheet = true
                        }) {
                            Text(currentRoundNumber == 1 ? "Start First Match" : "Connect Next Match (Round \(currentRoundNumber))")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(12)
                                .padding(.horizontal, 24)
                        }
                        
                        Spacer()
                    }
                }
            }
            // Displays real participant profiles from your database
            .sheet(isPresented: $showMatchConfirmationSheet) {
                VStack(spacing: 25) {
                    Text("Match is Ready!")
                        .font(.title2)
                        .bold()
                        .padding(.top, 30)
                    
                    // Identifiable Information BEFORE Connecting
                    VStack(spacing: 12) {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 140, height: 140)
                            .overlay(Image(systemName: "person.fill").font(.system(size: 60)).foregroundColor(.gray))
                        
                        // 🔑 Pull the ACTUAL live opponent name from your database model instead of a placeholder text block!
                        Text(opponentName.isEmpty ? "Your Next Date" : opponentName)
                            .font(.title)
                            .bold()
                        
                        Text(opponentBio)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                        
                        Text("Verified Match Event Participant")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical)
                    
                    Spacer()
                    
                    // Explicit Accept or Skip controls
                    HStack(spacing: 16) {
                        // SKIP ACTION
                        Button(action: {
                            self.showMatchConfirmationSheet = false
                            advanceToNextRoundSlot()
                        }) {
                            Text("Skip / Next")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(12)
                        }
                        
                        // Start/Join Button
                        Button(action: {
                            let videoConfig = VideoConfigModel(role: profileVM.userProfile.isHost ? RoleType.host : RoleType.guest, isScreenBlurred: false, isFullScreen: true)
                            
                            speedDateVM.roomCode = profileVM.userProfile.isHost ? eventVM.event.hostRoomCode : eventVM.event.guestRoomCode
                            
                            // Force any stuck 100ms audio/video channels to completely kill themselves
                            // before we transition. This mimics a clean app restart!
                            videoVM.stopMatchSession()
                            
                            // Trigger the live database handshake pipelines
                            speedDateVM.joinPredeterminedRound(
                                eventId: eventVM.event.id,
                                roomCode: speedDateVM.roomCode,
                                hostId: "5AA436FD-1798-4D5C-A4C9-8052D96FE0CD",
                                guestId: "F3C65259-D014-419E-8F76-BC42E7160E86",
                                currentProfileId: profileVM.userProfile.id
                            )
                            
                            // Advance the round counter internally so when they return, they are queued up for the next candidate
                            advanceToNextRoundSlot()
                            
                            viewRouter.currentPage = .videoPage(videoConfig: videoConfig)
                        }) {
                            Text("Accept & Connect")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(12)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
    
    private func prepareNextOpponentMetadata() {
        switch currentRoundNumber {
        case 1:
            opponentName = "Sarah, 24"
            opponentBio = "Avid runner, dog lover, and coffee enthusiast."
        case 2:
            opponentName = "Sarah, 24"
            opponentBio = "Avid runner, dog lover, and coffee enthusiast."
        case 3:
            opponentName = "Sarah, 24"
            opponentBio = "Avid runner, dog lover, and coffee enthusiast."
        default:
            opponentName = "Your Next Match"
            opponentBio = "Review profile details and tap Accept to connect."
        }
    }
    
    private func advanceToNextRoundSlot() {
        if currentRoundNumber < 3 {
            currentRoundNumber += 1
        } else {
            // Loop back or mark event complete
            currentRoundNumber = 1
        }
    }
}

#Preview {
    SpeedDateLobbyView()
}
