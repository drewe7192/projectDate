//
//  VideoView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 3/29/25.
//
import SwiftUI
import HMSRoomKit

struct VideoView: View {
    @State private var isMicMuted: Bool = false
    @EnvironmentObject var speedDateVM: SpeedDateViewModel
    @EnvironmentObject var eventVM: EventViewModel
    let videoConfig: VideoConfigModel
    
    var body: some View {
        ZStack {
            if !speedDateVM.roomCode.isEmpty {
                HMSPrebuiltView(roomCode: speedDateVM.roomCode, isMicMuted: $isMicMuted)
                // 🔑 Crucial for Speed Dating: Forces a clean view re-draw for the new date
                    .id(speedDateVM.roomCode)
                    .blur(radius: videoConfig.isScreenBlurred ? 30 : 0)
                    .frame(maxWidth: videoConfig.isFullScreen ? .infinity : 350, maxHeight: videoConfig.isFullScreen ? .infinity : 250)
                    .cornerRadius(30)
                
                if videoConfig.isFullScreen {
                    FullScreenComponentsView(
                        role: videoConfig.role,
                        eventId: eventVM.event.id,
                        hostId: "5AA436FD-1798-4D5C-A4C9-8052D96FE0CD",
                        guestId: "F3C65259-D014-419E-8F76-BC42E7160E86"
                    )
                }
            } else {
                // Visual feedback while waiting for the next match
                VStack {
                    ProgressView()
                    Text("Finding your next match...")
                        .padding()
                }
            }
        }
    }
}

#Preview {
    VideoView(videoConfig: emptyVideoConfig)
        .environmentObject(SpeedDateViewModel())
}
