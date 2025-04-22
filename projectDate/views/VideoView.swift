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
    @State private var questions: [String] = ["Test1", "Test2", "Test3"]
    @Binding var isFullScreen: Bool
    
    var body: some View {
        ZStack{
            HMSPrebuiltView(roomCode: videoViewModel.roomCode, questions: self.questions, isFullScreen: self.$isFullScreen)
                .frame(width: isFullScreen ? .infinity : 350, height: isFullScreen ? .infinity : 380)
                .cornerRadius(30)
        }
    }
}

#Preview {
    VideoView(isFullScreen: .constant(false))
}
