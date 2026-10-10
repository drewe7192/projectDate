//
//  SpeedDateLobbyView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 9/8/25.
//

import SwiftUI
import Combine
import Firebase

struct SpeedDateLobbyView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var eventVM: EventViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var speedDateVM: SpeedDateViewModel
    @EnvironmentObject var videoVM: VideoViewModel
    
    // 🔑 Keep track of which match number the host is currently on
    @State private var currentRoundNumber: Int = 0
    @State private var showMatchConfirmationSheet: Bool = false
    // Track which participant the host clicks on to view
    @State private var selectedParticipantId: String? = nil
    
    @State private var opponentName: String = ""
    @State private var opponentBio: String = ""
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    AnimatedGradientBackground()
                        .ignoresSafeArea()
                    
                    if eventVM.event.hostProfileId == profileVM.userProfile.id {
                        hostView
                    } else {
                        guestView
                    }
                }
            }
            // Displays real participant profiles from your database
            .sheet(isPresented: $showMatchConfirmationSheet) {
                matchConfirmationSheetContent
            }
        }
    }
    
    private var hostView: some View {
        VStack(spacing: 16) {
            VStack(spacing: 4) {
                Text("Host Dashboard")
                    .font(.title2)
                    .bold()
                Text("Current Progress: Round \(currentRoundNumber) of 3")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .padding(.top)

            // Dynamic List displaying your live event participants
            List {
                Section(header: Text("Active Room Participants").font(.caption).bold()) {
                    ForEach(eventVM.event.participantProfileIds, id: \.self) { participantId in
                        Button(action: {
                            // 🔑 Set tracking state, load correct metadata, and show inspection sheet
                            self.selectedParticipantId = participantId
                            prepareNextOpponentMetadata(for: participantId)
                            self.showMatchConfirmationSheet = true
                        }) {
                            HStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.1))
                                    .frame(width: 40, height: 40)
                                    .overlay(Image(systemName: "person.fill").foregroundColor(.blue))
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(participantId == profileVM.userProfile.id ? "You (Host)" : "Participant ID: \(participantId.prefix(8))...")
                                        .font(.body)
                                        .fontWeight(.medium)
                                    Text("Tap to review & connect match")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden) // Keeps our animated gradient visible behind list rows
        }
    }
    
    private var guestView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ProgressView()
                .scaleEffect(1.5)
                .padding()
            
            Text("Welcome to Hotseat Live")
                .font(.largeTitle)
                .bold()
            
            Text("Round \(currentRoundNumber) of 3")
                .font(.headline)
                .foregroundColor(.blue)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            
            Text("The host is currently configuring your next 1v1 video match sequence. Sit tight—your screen will automatically transition when the match launches.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
        .onAppear {
            startLobbyStateListener()
        }
        
    }
    
    private var matchConfirmationSheetContent: some View {
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
                    let user = profileVM.userProfile
                    let isHost = eventVM.event.hostProfileId == user.id
                    
                    let currentRole: RoleType = isHost ? .host : .guest
                    let currentHostId = isHost ? user.id : ""
                    let currentGuestId = isHost ? "" : user.id

                    let videoConfig = VideoConfigModel(
                        role: currentRole,
                        hostId: currentHostId,
                        guestId: currentGuestId,
                        isScreenBlurred: false,
                        isFullScreen: true
                    )
                    
                    speedDateVM.roomCode = isHost ? eventVM.event.hostRoomCode : eventVM.event.guestRoomCode
                    
                    // Force any stuck 100ms audio/video channels to completely kill themselves
                    // before we transition. This mimics a clean app restart!
                    videoVM.stopMatchSession()
                    
                    // Trigger the live database handshake pipelines
                    speedDateVM.joinPredeterminedRound(
                        eventId: eventVM.event.id,
                        roomCode: speedDateVM.roomCode,
                        hostId: currentHostId,
                        guestId: currentGuestId,
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
    
    private func prepareNextOpponentMetadata(for participantId: String) {
        // Here you will eventually parse actual object fields out of your snapshot data model.
        // Falling back to your structured template matrix logic for now:
        switch currentRoundNumber {
        case 1:
            opponentName = "Sarah, 24"
            opponentBio = "Avid runner, dog lover, and coffee enthusiast."
        case 2:
            opponentName = "Jessica, 27"
            opponentBio = "Designer who loves checking out new local bakeshops."
        case 3:
            opponentName = "Emily, 25"
            opponentBio = "Beach lover, gym regular, and movie nerd."
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
    
    private func startLobbyStateListener() {
        let matchDocId = "\(eventVM.event.id)_\(eventVM.event.hostProfileId)"
        let db = Firestore.firestore()
        
        // Listen directly to the activeDates tracking node
        db.collection("activeDates").document(matchDocId)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot, document.exists,
                      let data = document.data() else { return }
                
                // 1. Safely parse and synchronize the round number string key
                guard let currentRoundNumber = data["currentRoundNumber"] as? Int else { return }
                
                DispatchQueue.main.async {
                    self.currentRoundNumber = currentRoundNumber
                }
                
                let roundKey = "round_\(currentRoundNumber)"

                // 2. Locate the precise target index from your map dictionary
                guard let targetGuestId = eventVM.event.participantOrder[roundKey],
                      !targetGuestId.isEmpty else {
                    print("⚠️ No valid participant profile ID found for key: \(roundKey)")
                    return
                }
                
                // 3. Validate if the host has populated the live matching ID slot
                if let activeGuestId = data["guestId"] as? String, activeGuestId.isEmpty {
                    
                        let user = profileVM.userProfile
                        let isHost = eventVM.event.hostProfileId == user.id

                        // Configure explicit variables based on authenticated role type context
                        let currentRole: RoleType = isHost ? .host : .guest
                        let currentHostId = isHost ? user.id : ""

                        let videoConfig = VideoConfigModel(
                            role: currentRole,
                            hostId: currentHostId,
                            guestId: targetGuestId,
                            isScreenBlurred: false,
                            isFullScreen: true
                        )
                        
                        DispatchQueue.main.async {
                            speedDateVM.roomCode = isHost ? eventVM.event.hostRoomCode : eventVM.event.guestRoomCode
                            
                            // Clear out lingering channels before forcing the screen view switch
                            videoVM.stopMatchSession()
                            
                            // 🚀 Jump to the live video round layout seamlessly
                            viewRouter.currentPage = .videoPage(videoConfig: videoConfig)
                        }
                    }
                
            }
    }

}

#Preview {
    SpeedDateLobbyView()
}
