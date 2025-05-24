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
    @State private var questions: [String] = ["Test1", "Test2", "Test3"]
    
    var body: some View {
        ZStack{
            HMSPrebuiltView(roomCode: videoViewModel.roomCode)
                .frame(width: delegate.isFullScreen ? .infinity : 350, height: delegate.isFullScreen ? .infinity : 380)
                .cornerRadius(30)
            
            if delegate.isFullScreen {
                FullScreenComponentsView()
            }
        }
    }
}

#Preview {
    VideoView()
}
