//
//  HomeView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 2/18/25.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @State private var videoConfig: VideoConfigModel = emptyVideoConfig
    @State private var isHeartSelected: Bool = false
    @State private var showingNewAnswersSheet = false
    @State private var selectedOptions: Set<String> = []
    @State private var navigateToSpeedDate = false
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var speedDateVM: SpeedDateViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var eventVM: EventViewModel
    
    @Binding var selectedTab: Int
    
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedGradientBackground()
                    .ignoresSafeArea()
                
                GeometryReader { geometry in
                    VStack {
                        header(geometry: geometry)
                        
                        Spacer()
                            .frame(height: geometry.size.height * 0.03)
                        
                        videoSection(geometry: geometry)
                        
                        Spacer()
                            .frame(height: geometry.size.height * 0.05)
                        
                        let isParticipant = eventVM.event.participantProfileIds.contains(profileVM.userProfile.id)
                        let isUpcomingEvent  = eventVM.event.startDate > currentTime
                        let isCompletedEvent = eventVM.event.endDate < currentTime
                        let isLiveEvent = currentTime >= eventVM.event.startDate && currentTime <= eventVM.event.endDate
                        
                        GlassContainer {
                            mainButttonSection(isParticipant: isParticipant, isUpcomingEvent: isUpcomingEvent, isCompletedEvent: isCompletedEvent, isLiveEvent: isLiveEvent)
                        }
                        .frame(height: geometry.size.height * 0.1)
                        
                        Spacer()
                        
                        if isCompletedEvent || !isParticipant{
                            registerOverlaySection
                        }
                        Spacer()
                    }
                }
            }
            .task {
                if let _ = Auth.auth().currentUser {
                    do {
                        try await profileVM.getUserProfile()
                        
                        if !profileVM.userProfile.roomCode.isEmpty {
                            speedDateVM.roomCode = profileVM.userProfile.roomCode
                        }
                        
                        try await eventVM.getEvent(profileId: profileVM.userProfile.id)
                        // 3. Update currentTime explicitly after network fetching completes
                        currentTime = Date()
                        print(currentTime)
                        print(eventVM.event.startDate)
                        
                        try await profileVM.getFileFromStorage(profileId: profileVM.userProfile.id)
                    } catch {
                        print("Error getting userProfile:\(error)")
                    }
                }
            }
            .onDisappear {
                speedDateVM.roomCode = ""
            }
            // 4. Listen on the top level stack container so state cycles cleanly
            .onReceive(timer) { input in
                currentTime = input
            }
        }
    }
    
    
    private func header(geometry: GeometryProxy) -> some View {
        HStack{
            Circle()
                .frame(width: geometry.size.width * 0.08)
                .overlay {
                    if !profileVM.userProfile.profileImage.size.height.isZero {
                        Circle()
                            .overlay(
                                Image(uiImage: profileVM.userProfile.profileImage)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                            )
                            .frame(width: geometry.size.width * 0.09)
                        
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: geometry.size.width * 0.01, height: geometry.size.height * 0.01)
                    }
                }
                .padding(.leading)
                .onTapGesture {
                    selectedTab = 1
                }
            
            Spacer()
            Text("HotSeat")
                .font(.custom("Copperplate", size: geometry.size.height * 0.025))
                .foregroundColor(Color("tertiaryColor"))
                .bold()
            Image("logo")
                .resizable()
                .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)
            Text("Live")
                .font(.custom("Copperplate", size: geometry.size.height * 0.025))
                .foregroundColor(Color("tertiaryColor"))
                .bold()
            
            Spacer()
            
            Button(action : {
                viewRouter.currentPage = .notificationsPage
            }){
                Image(systemName: "bell.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * 0.07)
                    .foregroundColor(Color("tertiaryColor"))
                    .padding(.horizontal)
                    .clipShape(Circle())
            }
        }
    }
    
    private func videoSection(geometry: GeometryProxy) -> some View {
        VStack {
            if !speedDateVM.roomCode.isEmpty {
                VideoView(videoConfig: videoConfig)
            }
            else {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.primaryColor)
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.2)
                    .overlay {
                        VStack {
                            ProgressView {
                                
                            }
                            .scaleEffect(x: 4, y: 4, anchor: .center)
                            .padding(.bottom)
                            
                            Text("Joining room...")
                                .font(.system(size: 25))
                                .bold()
                                .foregroundColor(.black)
                        }
                    }
            }
        }
    }
    
    /// Converts the target Date into a readable string (e.g., "Oct 15, 7:00 PM")
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    /// Calculates the difference between two times and builds a "00:00:00" string
    private func countdownString(from now: Date, to target: Date) -> String {
        let diff = Int(target.timeIntervalSince(now))
        
        guard diff > 0 else { return "00:00:00" }
        
        let hours = diff / 3600
        let minutes = (diff % 3600) / 60
        let seconds = diff % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    @ViewBuilder
    private func countdownOverlaySection(isUpcomingEvent: Bool, isCompletedEvent: Bool, isLiveEvent: Bool) -> some View {
        VStack {
            if isUpcomingEvent {
                Text("Starts: \(formattedDate(eventVM.event.startDate))")
                    .font(.system(size: 24))
                    .foregroundStyle(.white.opacity(0.8))
                
                Text("Starts in: \(countdownString(from: currentTime, to: eventVM.event.startDate))")
                    .font(.system(size: 24, design: .monospaced))
                    .foregroundStyle(.yellow)
            } else if isLiveEvent {
                Text("Event Started Live!")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(.green)
            } else if isCompletedEvent {
                Text("Event Has Ended!")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(.green)
            }
        }
        .id(eventVM.event.startDate) // 🔑 Explicitly triggers structural invalidation
    }
    
    @ViewBuilder
    private var registerOverlaySection: some View {
        VStack(spacing: 12) {
            Text("Ready to jump in the HotSeat?")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            
            Text("Live events require registration. Connect below to get added to the next round:")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
            
            HStack(spacing: 12) {
                Link(destination: URL(string: "mailto:joinhotseatapp@gmail.com")!) {
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("Email")
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                
                Link(destination: URL(string: "https://www.linkedin.com/in/drewe7192/")!) {
                    HStack {
                        Image(systemName: "person.crop.circle.badge.plus")
                        Text("Developer")
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.white.opacity(0.3), lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, 12)
        }
        .padding(.vertical, 16)
        .background(Color.black.opacity(0.4))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.15), lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .frame(minHeight: 20)
    }
    
    @ViewBuilder
    private func mainButttonSection(isParticipant: Bool, isUpcomingEvent: Bool, isCompletedEvent: Bool, isLiveEvent: Bool) -> some View {
        VStack{
            Button(action: {
                navigateToSpeedDate = true
                viewRouter.currentPage = .speedDateLobby
            }) {
                VStack{
                    let text: String = {
                        switch (isLiveEvent, isUpcomingEvent, isParticipant) {
                        case (true, _, true):
                            return "Start Speed Date"
                        case (false, false, true):
                            return "No Upcoming Events"
                        case (false, false, false):
                            return "No Upcoming Events"
                        default:
                            return ""
                        }
                    }()
                    
                    Spacer()
                    Text(text)
                        .foregroundStyle(.white)
                        .font(.system(size: 20, weight: .bold))
                    
                    if isParticipant && isUpcomingEvent {
                        countdownOverlaySection(isUpcomingEvent: isUpcomingEvent, isCompletedEvent: isCompletedEvent, isLiveEvent: isLiveEvent)
                    }
                    Spacer()
                    
                }
            }
            .disabled(!isParticipant || isCompletedEvent || isUpcomingEvent )
            .opacity(!isParticipant || isCompletedEvent ? 0.2: 0.5)
        }
        .navigationDestination(isPresented: $navigateToSpeedDate) {
            SpeedDateLobbyView()
        }
    }
}

#Preview {
    HomeView(selectedTab: .constant(0))
        .environmentObject(ProfileViewModel())
        .environmentObject(SpeedDateViewModel())
        .environmentObject(AppDelegate())
}
