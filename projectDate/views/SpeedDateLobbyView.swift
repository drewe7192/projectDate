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
    
    @State private var showMatchConfirmationSheet: Bool = false
    @State private var isHostWaitingForMe: Bool = false
    
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
            .sheet(isPresented: $showMatchConfirmationSheet) {
                matchConfirmationSheetContent
            }
        }
    }
    
    // MARK: - HOST VIEW
    private var hostView: some View {
        VStack(spacing: 24) {
            Spacer()
            hostViewHeader
            participantList
            Spacer()
            matchButton // Automatically targets the precise user assigned to this round
            Spacer()
        }
        .onAppear {
            startHostLobbySyncListener()
            Task {
                try await profileVM.getProfiles(profileIds: eventVM.event.participantProfileIds)
            }
        }
    }
    
    // MARK: - GUEST VIEW
    private var guestView: some View {
        VStack(spacing: 20) {
            Spacer()
            guestHeader
            guestFooter
            Spacer()
        }
        .onAppear {
            startGuestLobbyStateListener()
        }
    }
    
    private var hostViewHeader: some View {
        VStack(spacing: 8) {
            Text("HotSeat Lobby")
                .font(.largeTitle)
                .bold()
            
            Text("Round \(videoVM.currentRoundNumber) of 3")
                .font(.title3)
                .foregroundColor(.blue)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
        }
    }
    
    private var participantList: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 🔑 Loops through the sorted keys and matches them to profiles dynamically
            let sortedActiveGuests: [ProfileModel] = {
                // 1. Get the raw keys sorted by round order sequence (e.g., ["round_1", "round_2", "round_3"])
                let sortedRoundKeys = eventVM.event.participantOrder.keys.sorted { key1, key2 in
                    // Extract numbers from "round_1", "round_2" to sort numerically
                    let num1 = Int(key1.replacingOccurrences(of: "round_", with: "")) ?? 0
                    let num2 = Int(key2.replacingOccurrences(of: "round_", with: "")) ?? 0
                    return num1 < num2
                }
                
                // 2. Map the keys directly to their profile IDs, filtering out the Host
                let sequentialProfileIds = sortedRoundKeys.compactMap { eventVM.event.participantOrder[$0] }
                    .filter { $0 != profileVM.userProfile.id }
                
                // 3. Match those sequential IDs against the loaded profiles array in memory
                return sequentialProfileIds.compactMap { targetId in
                    profileVM.guestProfiles.first(where: { $0.id == targetId })
                }
            }()
            
            Text("\(sortedActiveGuests.count) Guests in Queue")
                .font(.caption)
                .bold()
                .foregroundColor(.secondary)
                .padding(.horizontal, 24)
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(sortedActiveGuests, id: \.self) { guestProfile in
                        HStack {
                            Circle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 36, height: 36)
                                .overlay(Image(systemName: "person.fill").foregroundColor(.gray))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(guestProfile.name)
                                    .font(.subheadline)
                                    .bold()
                                    .lineLimit(1)
                                
                                Text("ID: \(guestProfile.id.prefix(8))...")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            //Check if this guest is the one assigned to the current round
                            let roundKey = "round_\(videoVM.currentRoundNumber)"
                            if eventVM.event.participantOrder[roundKey] == guestProfile.id {
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
    }
    
    private var matchButton: some View {
        VStack {
            Button(action: {
                Task {
                    let roundKey = "round_\(videoVM.currentRoundNumber)"
                    
                    // Look up the profile ID assigned to this round key string directly
                    if let targetedGuestId = eventVM.event.participantOrder[roundKey] {
                        await prepareNextOpponentMetadata(for: targetedGuestId)
                    } else {
                        print("⚠️ No sequential match mapped for key: \(roundKey)")
                    }
                }
            }) {
                Text(videoVM.currentRoundNumber == 1 ? "Launch First Match" : "Connect Next Match (Round \(videoVM.currentRoundNumber))")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
            }
        }
    }
    
    private var guestHeader: some View {
        VStack {
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
            
            Text("Round \(videoVM.currentRoundNumber) of 3")
                .font(.headline)
                .foregroundColor(.blue)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
        }
    }
    
    private var guestFooter: some View {
        VStack {
            Text(isHostWaitingForMe ? "The host has opened your room and is ready to talk! Tap below to join your 1v1 video match." : "The host is currently configuring your next 1v1 video match sequence. Sit tight—your screen will update when the match launches.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
            
            if isHostWaitingForMe {
                guestLaunchButton
            }
        }
    }
    
    private var guestLaunchButton: some View {
        VStack {
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
                videoVM.endRoundCleanly()
                
                speedDateVM.roomCode = ""
                
                // 🚀 STEP 2: Introduce a minor main actor execution delay (150ms)
                // This forces SwiftUI to fully unmount any lingering RTC video track allocations
                // from previous rounds before Phone 3 initializes its stream channel!
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    
                    // Re-bind the static room code token cleanly now that the cache is flushed
                    speedDateVM.roomCode = eventVM.event.guestRoomCode
                    print("📱 3rd Phone: Static room code re-initialized cleanly for Round 2: \(speedDateVM.roomCode)")
                    
                    // Trigger the database round state transitions
                    speedDateVM.joinPredeterminedRound(
                        eventId: eventVM.event.id,
                        roomCode: speedDateVM.roomCode,
                        hostId: eventVM.event.hostProfileId,
                        guestId: user.id,
                        currentProfileId: user.id
                    )
                    
                    // Clear local button state flags and safely push them into the fresh video layout view tree
                    self.isHostWaitingForMe = false
                    viewRouter.currentPage = .videoPage(videoConfig: videoConfig)
                }
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
    
    private var matchConfirmationSheetContent: some View {
        VStack(spacing: 25) {
            Text("Match is Ready!")
                .font(.title2)
                .bold()
                .padding(.top, 30)
            
            matchConfirmationSheetBody
                .padding(.vertical)
            
            Spacer()
            matchConfirmationSheetControls
        }
    }
    
    private var matchConfirmationSheetBody: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 140, height: 140)
                .overlay(Image(systemName: "person.fill").font(.system(size: 60)).foregroundColor(.gray))
            
            Text(profileVM.guestProfile.name.isEmpty ? "Your Next Date" : profileVM.guestProfile.name)
                .font(.title)
                .bold()
            
            Text(profileVM.guestProfile.bio ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Text("Verified Match Event Participant")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var matchConfirmationSheetControls: some View {
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
                let hostId = eventVM.event.hostProfileId
                let matchDocId = "\(eventVM.event.id)_\(hostId)"
                
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
                
                
                // 🔑 THE FIX: Transition the server state from "review" to "waiting"
                // right here to signal the Guest that the Host is officially inside the room!
                let db = Firestore.firestore()
                db.collection("activeDates").document(matchDocId).updateData([
                    "status": "waiting" // 🚀 This is the exact moment the Guest's green button will unlock!
                ])
                
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
    
    private func prepareNextOpponentMetadata(for participantId: String) async {
        print("🔍 Fetching live profile data for matching tester ID: \(participantId)")
        do {
            try await profileVM.getProfile(profileId: participantId)
            
            // 🔒 Safe MainActor scheduling replaces the old DispatchQueue format cleanly
            await MainActor.run {
                self.showMatchConfirmationSheet = true
            }
        } catch {
            print("❌ Failed to fetch user profile metadata: \(error.localizedDescription)")
        }
    }
    
    private func advanceToNextRoundSlot() {
        if videoVM.currentRoundNumber < 3 {
            videoVM.currentRoundNumber += 1
        } else {
            // Loop back or mark event complete
            videoVM.currentRoundNumber = 1
        }
    }
    
    private func startHostLobbySyncListener() {
        let db = Firestore.firestore()
        let currentEventId = eventVM.event.id
        let hostId = eventVM.event.hostProfileId
        let matchDocId = "\(currentEventId)_\(hostId)"
        
        print("👑 Host: Attaching dashboard synchronization listener on node: \(matchDocId)")
        
        db.collection("activeDates").document(matchDocId)
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print("❌ Host sync error: \(error.localizedDescription)")
                    return
                }
                
                guard let document = documentSnapshot, document.exists,
                      let data = document.data() else {
                    print("ℹ️ No active dates document found. Initializing on Round 1 baseline.")
                    return
                }
                
                // Safely parse and bind the server round number straight to videoVM!
                if let serverRoundNumber = data["currentRoundNumber"] as? Int {
                    DispatchQueue.main.async {
                        // Update your shared video view-model property so the entire view re-orders instantly!
                        videoVM.currentRoundNumber = serverRoundNumber
                        print("👑 Host synchronized current round from database: \(serverRoundNumber)")
                    }
                }
            }
    }
    
    private func startGuestLobbyStateListener() {
        let currentUserId = profileVM.userProfile.id
        let hostId = eventVM.event.hostProfileId
        let matchDocId = "\(eventVM.event.id)_\(hostId)"
        
        print("📱 Starting lobby state ear listener on document node: \(matchDocId)")
        
        // 💡 Tip: You can pass includeMetadataChanges: false here if you want to bypass local caches entirely
        _ = Firestore.firestore().collection("activeDates").document(matchDocId)
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print("❌ Firestore real-time listener error: \(error.localizedDescription)")
                    return
                }
                
                guard let document = documentSnapshot else { return }
                
                // 🚀 STEP A: Extract global metrics before caching or deletion barriers can touch them!
                guard let data = document.data(),
                      let serverRoundNumber = data["currentRoundNumber"] as? Int else { return }
                
                DispatchQueue.main.async {
                    if videoVM.currentRoundNumber != serverRoundNumber {
                        videoVM.currentRoundNumber = serverRoundNumber
                        print("📱 Guest view-model synchronized to round: \(serverRoundNumber)")
                    }
                }
                
                // 🛡️ STEP B: Delegate state shields to dedicated sub-components
                if document.metadata.isFromCache {
                    handleStaleCacheOnStartup()
                    return
                }
                
                guard document.exists else {
                    handleMatchSessionDeletion()
                    return
                }
                
                // 🔀 STEP C: Delegate schedule matching and room navigation
                processLiveLobbyPayload(data, serverRoundNumber: serverRoundNumber, hostId: hostId, currentUserId: currentUserId, defaultRoomCode: document.documentID)
            }
    }
    
    private func handleStaleCacheOnStartup() {
        print("⚠️ Ignoring stale local cache payload on startup. Waiting for real-time server verification...")
        DispatchQueue.main.async {
            self.isHostWaitingForMe = false
            resetToLobbyIfNeeded()
        }
    }
    
    private func handleMatchSessionDeletion() {
        print("🧹 Server confirmed document does not exist. Grounding Guest safely to Lobby Screen.")
        DispatchQueue.main.async {
            self.isHostWaitingForMe = false
            speedDateVM.roomCode = ""
            videoVM.stopMatchSession()
            resetToLobbyIfNeeded()
        }
    }
    
    private func processLiveLobbyPayload(_ data: [String: Any], serverRoundNumber: Int, hostId: String, currentUserId: String, defaultRoomCode: String) {
        // Build lookup pattern matching your updated schedule map matrix using the local parsed round integer
        let roundKey = "round_\(serverRoundNumber)"
        
        // Extract the target profile ID assigned to this specific round sequence loop
        guard let targetGuestId = eventVM.event.participantOrder[roundKey], !targetGuestId.isEmpty else {
            print("⚠️ System Matrix Mismatch: No guest mapping exists for key '\(roundKey)'")
            return
        }
        
        // 🔒 SECURITY CHECK GATEWAY: Stop here if this device isn't the scheduled round target match entry
        guard currentUserId == targetGuestId else {
            print("🔒 Secure Filter: User is a spectator for Round \(serverRoundNumber). Hiding call buttons.")
            DispatchQueue.main.async { self.isHostWaitingForMe = false }
            return
        }
        
        // Extract room routing flags and signaling channel tokens
        let status = data["status"] as? String ?? ""
        
        DispatchQueue.main.async {
            // 🔀 DYNAMIC STATE EVALUATION INTERCEPTOR:
            if status == "waiting" {
                self.isHostWaitingForMe = true
                print("💚 Host is checked into the room waiting for you. Revealing Call Button.")
                
            } else if status == "active" {
                // 🔒 THE ABSOLUTE NAVIGATIONAL LIFEGUARD FIX:
                // If the 3rd phone has ALREADY successfully broken out of the lobby and is rendering the call page,
                // immediately exit the block! Do NOT re-trigger view allocation states or overwrite the router!
                switch viewRouter.currentPage {
                case .videoPage(_):
                    print("🛡️ Listener Shield: Guest is already actively on the video call page. Aborting redundant layout re-pushes.")
                    return // 🚀 EXIT THE FUNCTION PASS COMPLETELY!
                default:
                    break // Not on the video page yet, allow them to pass through safely below
                }
                
                // 🚀 Only runs if they are physically still sitting in the lobby room waiting area!
                self.isHostWaitingForMe = false
                
                let videoConfig = VideoConfigModel(
                    role: .guest,
                    hostId: hostId,
                    guestId: currentUserId,
                    isScreenBlurred: false,
                    isFullScreen: true
                )
                
                speedDateVM.roomCode = eventVM.event.guestRoomCode
                print("🚀 Match state confirmed active! Transitioning Guest to video view layout container.")
                viewRouter.currentPage = .videoPage(videoConfig: videoConfig)
            } else {
                // 🔒 SAFETY BUFFER MAPPING: Covers "review", "completed", or empty database transitions
                // This ensures the green button drops off instantly the second a round clears!
                self.isHostWaitingForMe = false
            }
        }
    }
    
    private func resetToLobbyIfNeeded() {
        switch viewRouter.currentPage {
        case .speedDateLobby:
            break // Already safely anchored inside the lobby layout view tree workspace
        default:
            viewRouter.currentPage = .speedDateLobby
        }
    }
}

#Preview {
    SpeedDateLobbyView()
}
