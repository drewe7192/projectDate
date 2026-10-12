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
                try await profileVM.GetProfiles(profileIds: eventVM.event.participantProfileIds)
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
            startLobbyStateListener()
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
                
                // 🚀 Fills guestId slot, flips room to active, and schedules Cloud Task timer!
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
    
    private func prepareNextOpponentMetadata(for participantId: String) async {
        print("🔍 Fetching live profile data for matching tester ID: \(participantId)")
        do {
            try await profileVM.GetProfile(profileId: participantId)
            
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
    
    private func startLobbyStateListener() {
        let db = Firestore.firestore()
        let currentUserId = profileVM.userProfile.id
        let currentEventId = eventVM.event.id
        let hostId = eventVM.event.hostProfileId
        let matchDocId = "\(currentEventId)_\(hostId)"
        
        print("📱 Starting lobby state ear listener on document node: \(matchDocId)")
        
        db.collection("activeDates").document(matchDocId)
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print("❌ Firestore real-time listener error: \(error.localizedDescription)")
                    return
                }
                
                guard let document = documentSnapshot else { return }
                // gotta get this before the media cache... maybe fix later?
                guard let data = document.data(),
                      let serverRoundNumber = data["currentRoundNumber"] as? Int else { return }
                print(serverRoundNumber)
                DispatchQueue.main.async {
                    videoVM.currentRoundNumber = serverRoundNumber
                }
                
                
                // 🔑 THE CACHE SHIELD: If the data is from local cache and the document isn't fully verified on the server yet,
                // freeze navigation and force the app to stay in the lobby waiting view!
                if document.metadata.isFromCache {
                    print("⚠️ Ignoring stale local cache payload on startup. Waiting for real-time server verification...")
                    DispatchQueue.main.async {
                        self.isHostWaitingForMe = false
                        // 🔑 COMPILER-PROOF CHECK: Use a switch to check the page safely without Equatable errors!
                        switch viewRouter.currentPage {
                        case .speedDateLobby:
                            break // Already safely in the lobby workspace, do nothing!
                        default:
                            viewRouter.currentPage = .speedDateLobby // Push them back to the lobby
                        }
                    }
                    return
                }
                
                // 🧹 If the document doesn't exist on the server (because you deleted it), clean up memory cleanly!
                guard document.exists else {
                    print("🧹 Server confirmed document does not exist. Grounding Guest safely to Lobby Screen.")
                    DispatchQueue.main.async {
                        self.isHostWaitingForMe = false
                        self.activeRoomCode = ""
                        speedDateVM.roomCode = ""
                        videoVM.stopMatchSession()
                        // 🔑 COMPILER-PROOF CHECK: Use a switch to check the page safely without Equatable errors!
                        switch viewRouter.currentPage {
                        case .speedDateLobby:
                            break // Already safely in the lobby workspace, do nothing!
                        default:
                            viewRouter.currentPage = .speedDateLobby // Push them back to the lobby
                        }
                    }
                    return
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
