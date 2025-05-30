//
//  VideoView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 3/29/25.
//
import SwiftUI
import HMSRoomKit

struct VideoView: View {
    let isFullScreen: Bool
    @EnvironmentObject var videoViewModel: VideoViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    
    var body: some View {
        ZStack{
            HMSPrebuiltView(roomCode: videoViewModel.roomCode)
                .blur(radius: eventViewModel.isBlurredScreen ? 30 : 0)
                .frame(width: self.isFullScreen ? .infinity : 350, height: self.isFullScreen ? .infinity : 380)
                .cornerRadius(30)
            
            if self.isFullScreen {
                FullScreenComponentsView()
            }
        }
    }
}

#Preview {
    VideoView(isFullScreen: false)
}
