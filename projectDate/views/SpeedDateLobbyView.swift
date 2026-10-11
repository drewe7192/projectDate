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
    @State private var currentRoundNumber: Int = 1
    @State private var showMatchConfirmationSheet: Bool = false
    // Track which participant the host clicks on to view
    @State private var selectedParticipantId: String? = nil
    
    @State private var opponentName: String = ""
    @State private var opponentBio: String = ""
    
    @State private var isHostWaitingForMe: Bool = false
    @State private var activeRoomCode: String = ""
    
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
    
    // MARK: - 👑 1. FIXED HOST VIEW (Sequential Automation)
    private var hostView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 8) {
                Text("Host Control Dashboard")
                    .font(.largeTitle)
                    .bold()
                
                Text("Round \(currentRoundNumber) of 3")
                    .font(.title3)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
            }
            
            // 🔒 Visual Roster Preview: Filters out the Host automatically so they are never listed
            let activeGuests = eventVM.event.participantProfileIds.filter { $0 != profileVM.userProfile.id }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Sequential Queue (\(activeGuests.count) Guests Registered)")
                    .font(.caption)
                    .bold()
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 24)
                
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(activeGuests, id: \.self) { guestId in
                            HStack {
                                Circle()
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(width: 36, height: 36)
                                    .overlay(Image(systemName: "person.fill").foregroundColor(.gray))
                                
                                Text("Tester ID: \(guestId.prefix(8))...")
                                    .font(.subheadline)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                // Check if this guest is the one assigned to the current round
                                let roundKey = "round_\(currentRoundNumber)"
                                if eventVM.event.participantOrder[roundKey] == guestId {
                                    Text("Up Next")
                                        .font(.caption2)
                                        .bold()
                                        .foregroundColor(.green)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.green.opacity(0.1))
                                        .cornerRadius(6)
                                }
                            }
                            .padding()
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .frame(maxHeight: 200)
            }
            
            Spacer()
            
            // 🔑 THE SEQUENTIAL TRIGGER: Automatically targets the precise user assigned to this round
            Button(action: {
                let roundKey = "round_\(currentRoundNumber)"
                
                // Look up the profile ID assigned to this round key string directly
                if let targetedGuestId = eventVM.event.participantOrder[roundKey] {
                    self.selectedParticipantId = targetedGuestId
                    prepareNextOpponentMetadata(for: targetedGuestId)
                    self.showMatchConfirmationSheet = true
                } else {
                    print("⚠️ No sequential match mapped for key: \(roundKey)")
                }
            }) {
                Text(currentRoundNumber == 1 ? "Launch First Match" : "Connect Next Match (Round \(currentRoundNumber))")
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
    
    // MARK: - 📱 2. GUEST VIEW (Interactive Wait State)
    private var guestView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            if !isHostWaitingForMe {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
            } else {
                Image(systemName: "video.badge.plus.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.green)
                    .padding()
            }
            
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
            
            // Dynamic text updates based on host configuration actions
            Text(isHostWaitingForMe ? "The host has opened your room and is ready to talk! Tap below to join your 1v1 video match." : "The host is currently configuring your next 1v1 video match sequence. Sit tight—your screen will update when the match launches.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
            
            // 🔑 GUEST CALL-IN ACTION TRIGGER: Becomes visible the exact millisecond status == "waiting"
            if isHostWaitingForMe {
                Button(action: {
                    let user = profileVM.userProfile
                    let videoConfig = VideoConfigModel(
                        role: .guest,
                        hostId: eventVM.event.hostProfileId,
                        guestId: user.id,
                        isScreenBlurred: false,
                        isFullScreen: true
                    )
                    
                    // Kill any stale 100ms background pipeline audio nodes
                    videoVM.stopMatchSession()
                    
                    // 🚀 STEP 2 HANDSHAKE INVOCATION: Fills guestId slot, flips room to active, and schedules Cloud Task timer!
                    speedDateVM.joinPredeterminedRound(
                        eventId: eventVM.event.id,
                        roomCode: self.activeRoomCode,
                        hostId: eventVM.event.hostProfileId,
                        guestId: user.id,
                        currentProfileId: user.id
                    )
                    
                    // Clear state out locally and push onto the video stream page layer layout
                    self.isHostWaitingForMe = false
                    viewRouter.currentPage = .videoPage(videoConfig: videoConfig)
                }) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("Enter Hotseat Video Call")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(12)
                    .padding(.horizontal, 32)
                    .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.bottom, 20)
            }
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
        let db = Firestore.firestore()
        let currentUserId = profileVM.userProfile.id
        let currentEventId = eventVM.event.id
        let hostId = eventVM.event.hostProfileId
        
        // 🔑 Generates the uniform document path matching the Host's write signature
        let matchDocId = "\(currentEventId)_\(hostId)"
        
        print("📱 Starting lobby state ear listener on document node: \(matchDocId)")
        
        db.collection("activeDates").document(matchDocId)
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print("❌ Firestore real-time listener error: \(error.localizedDescription)")
                    return
                }
                
                guard let document = documentSnapshot, document.exists,
                      let data = document.data() else {
                    print("⏳ Active date tracking node is empty or unpopulated.")
                    return
                }
                
                // 1. Sync the current round state number down from the database driver
                guard let serverRoundNumber = data["currentRoundNumber"] as? Int else { return }
                
                DispatchQueue.main.async {
                    self.currentRoundNumber = serverRoundNumber
                }
                
                // 2. Build the string lookup pattern matching your updated [String: String] Map data model
                let roundKey = "round_\(serverRoundNumber)"
                
                // 3. Extract the target profile ID assigned to this specific round loop sequence
                guard let targetGuestId = eventVM.event.participantOrder[roundKey], !targetGuestId.isEmpty else {
                    print("⚠️ System Matrix Mismatch: No guest mapping exists for key '\(roundKey)'")
                    return
                }
                
                // 🔒 SECURITY CHECK: Stop here if this device profile isn't the one scheduled for this round
                guard currentUserId == targetGuestId else { return }
                
                // 4. Extract the room status string parameter and the active channel routing credentials
                let status = data["status"] as? String ?? ""
                let roomCode = data["hostRoomCode"] as? String ?? document.documentID
                
                DispatchQueue.main.async {
                    self.activeRoomCode = roomCode
                    
                    // 🔀 DYNAMIC STATE EVALUATION INTERCEPTOR:
                    if status == "waiting" {
                        // Host opened the space, reveal the interactive join call-in action button layer
                        self.isHostWaitingForMe = true
                        print("💚 Host is checked into the room waiting for you. Revealing Call Button.")
                        
                    } else if status == "active" {
                        // Backup check: If things bypass directly or handle rapid updates, push forward
                        self.isHostWaitingForMe = false
                        
                        let videoConfig = VideoConfigModel(
                            role: .guest,
                            hostId: hostId,
                            guestId: currentUserId,
                            isScreenBlurred: false,
                            isFullScreen: true
                        )
                        
                        speedDateVM.roomCode = roomCode
                        print("🚀 Match state changed to active! Moving Guest to video view layout.")
                        viewRouter.currentPage = .videoPage(videoConfig: videoConfig)
                    }
                }
            }
    }
}

#Preview {
    SpeedDateLobbyView()
}
