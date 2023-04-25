//
//  VideoView.swift
//  projectDate
//
//  Created by DotZ3R0 on 4/4/23.
//

import SwiftUI
import HMSSDK
import Foundation

//struct VideoView: UIViewRepresentable {
//    var track: HMSVideoTrack
//
//    func makeUIView(context: Context) -> HMSVideoView {
//    let videoView = HMSVideoView()
//        videoView.setVideoTrack(track)
//        videoView.backgroundColor = UIColor.black
//        return videoView
//    }
//
//    func updateUIView(_ videoView: HMSVideoView, context: Context) {
//        videoView.setVideoTrack(track)
//    }
//}

struct VideoView: UIViewRepresentable {
    var track: HMSVideoTrack

    func makeUIView(context: Context) -> HMSVideoView {
        
        let videoView = HMSVideoView()
        videoView.setVideoTrack(track)
        videoView.backgroundColor = UIColor.black
        videoView.videoContentMode = .scaleAspectFill
        return videoView
    }
    
    func updateUIView(_ videoView: HMSVideoView, context: Context) {}
}

