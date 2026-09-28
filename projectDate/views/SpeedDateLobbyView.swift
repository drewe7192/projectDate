//
//  SpeedDateLobbyView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 9/8/25.
//

import SwiftUI
import Combine

struct Participant: Identifiable {
    let id = UUID()
    let name: String
    let isReady: Bool
}

struct SpeedDateLobbyView: View {
    @State private var participants: [Participant] = [
        Participant(name: "Alice", isReady: true),
        Participant(name: "Bob", isReady: false),
        Participant(name: "Charlie", isReady: true),
        Participant(name: "Diana", isReady: true)
    ]
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var eventVM: EventViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var videoVM: VideoViewModel
    
    // Countdown to next speed date
    @State private var timeRemaining: String = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Target date for countdown (example: next Sunday midnight)
    let targetDate: Date = {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let daysToAdd = 8 - weekday
        return calendar.startOfDay(for: calendar.date(byAdding: .day, value: daysToAdd, to: today)!)
    }()
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    AnimatedGradientBackground()
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("SpeedDate Lobby")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.white)
                        
                        Spacer()
                            .frame(maxHeight: 30)
                        
                        GlassContainer {
                            VStack {
                                Text("Next SpeedDate starts in:")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text(timeRemaining)
                                    .font(.system(size: 36, weight: .bold, design: .monospaced))
                                    .foregroundColor(.blue)
                            }
                        }
                        .frame(maxHeight: 80)
                        
                        Spacer()
                            .frame(maxHeight: 40)
                        
                        // Participants list
                        VStack(alignment: .leading) {
                            Text("Participants")
                                .font(.headline)
                            
                            ScrollView {
                                VStack(spacing: 10) {
                                    ForEach(participants) { participant in
                                        GlassContainer {
                                            HStack {
                                                Text(participant.name)
                                                    .font(.title3)
                                                    .foregroundStyle(.white)
                                                Spacer()
                                                Circle()
                                                    .fill(participant.isReady ? Color.green : Color.gray)
                                                    .frame(width: 15, height: 15)
                                            }
                                            .padding()
                                            .cornerRadius(10)
                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        // Start/Join Button
                        Button(action: {
                            let videoConfig = VideoConfigModel(role: RoleType.host, isScreenBlurred: false, isFullScreen: true)
                            videoVM.roomCode = profileVM.userProfile.isHost ?  eventVM.event.hostRoomCode : eventVM.event.guestRoomCode
                            
                            viewRouter.currentPage = .videoPage(videoConfig: videoConfig)
                        }) {
                            Text("Join SpeedDate")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(12)
                                .shadow(radius: 4)
                        }
                    }
                }
            }
            .task {
                do {
                    updateTimeRemaining()
                    try await eventVM.GetEvent(eventId: profileVM.userProfile.eventId)
                } catch {
                    print("error occured in speeddating Lobby")
                }
            }
            .onReceive(timer) { _ in
                updateTimeRemaining()
            }
        }
    }
    
    func updateTimeRemaining() {
        let now = Date()
        let diff = targetDate.timeIntervalSince(now)
        
        if diff <= 0 {
            timeRemaining = "00d 00h 00m 00s"
        } else {
            let days = Int(diff) / (24 * 3600)
            let hours = (Int(diff) % (24 * 3600)) / 3600
            let minutes = (Int(diff) % 3600) / 60
            let seconds = Int(diff) % 60
            timeRemaining = String(format: "%02dd %02dh %02dm %02ds", days, hours, minutes, seconds)
        }
    }
}

#Preview {
    SpeedDateLobbyView()
}
