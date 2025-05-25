//
//  VideoView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 3/29/25.
//
import SwiftUI
import HMSRoomKit

struct VideoView: View {
    @EnvironmentObject var videoViewModel: VideoViewModel
    @EnvironmentObject var delegate: AppDelegate
    @EnvironmentObject var eventViewModel: EventViewModel
    
    var body: some View {
        ZStack{
            // prevents refresh of video
            if delegate.requestByProfile.roomCode == "" {
                HMSPrebuiltView(roomCode: videoViewModel.roomCode)
                    .frame(width: eventViewModel.isFullScreen ? .infinity : 350, height: eventViewModel.isFullScreen ? .infinity : 380)
                    .cornerRadius(30)
                
                if eventViewModel.isFullScreen {
                    FullScreenComponentsView()
                }
            }
        }
    }
}

#Preview {
    VideoView()
}
