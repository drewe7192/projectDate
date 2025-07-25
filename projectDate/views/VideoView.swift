//
//  VideoView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 3/29/25.
//
import SwiftUI
import HMSRoomKit

struct VideoView: View {
    let videoConfig: VideoConfigModel
    @EnvironmentObject var videoViewModel: VideoViewModel
    @State private var isMicMuted: Bool = false
    
    var body: some View {
        ZStack{
            if !videoViewModel.roomCode.isEmpty {
                HMSPrebuiltView(roomCode: videoViewModel.roomCode, isMicMuted: $isMicMuted)
                    .blur(radius: videoConfig.isScreenBlurred ? 30 : 0)
                    .frame(width: videoConfig.isFullScreen ? .infinity : 350, height: videoConfig.isFullScreen ? .infinity : 300)
                    .cornerRadius(30)
                
                if videoConfig.isFullScreen  {
                    FullScreenComponentsView(role: videoConfig.role, isMicMuted: $isMicMuted)
                }
            }
         
        }
    }
}

#Preview {
    VideoView(videoConfig: emptyVideoConfig)
}
