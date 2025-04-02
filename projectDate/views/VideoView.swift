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
    
    var body: some View {
        ZStack{
            HMSPrebuiltView(roomCode: videoViewModel.roomCode)
                .frame(width: videoViewModel.isFullScreen ? .infinity : 350, height: videoViewModel.isFullScreen ? .infinity : 380)
                .cornerRadius(30)
            
            if videoViewModel.isFullScreen {
                Circle()
                    .fill(.red)
                    .frame(width: 100, height: 100)
                    .overlay {
                        Image(systemName: "flag")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 40)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                    }
                    .opacity(videoViewModel.isButtonDisabled ? 0.4 : 1)
                    .disabled(videoViewModel.isButtonDisabled)
                    .position(x: 200 , y: 700)
            }
        }
    }
}

#Preview {
    VideoView()
}
