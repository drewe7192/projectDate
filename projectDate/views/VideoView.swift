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
    @EnvironmentObject var videoViewModel: VideoViewModel
    let videoConfig: VideoConfigModel
    
    var body: some View {
        ZStack {
            if !videoViewModel.roomCode.isEmpty {
                HMSPrebuiltView(roomCode: videoViewModel.roomCode, isMicMuted: $isMicMuted)
                    // 🔑 Crucial for Speed Dating: Forces a clean view re-draw for the new date
                    .id(videoViewModel.roomCode)
                    .blur(radius: videoConfig.isScreenBlurred ? 30 : 0)
                    .frame(width: videoConfig.isFullScreen ? .infinity : 350, height: videoConfig.isFullScreen ? .infinity : 250)
                    .cornerRadius(30)
                
                if videoConfig.isFullScreen {
                    FullScreenComponentsView(isMicMuted: $isMicMuted, role: videoConfig.role)
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
        .environmentObject(VideoViewModel())
}
