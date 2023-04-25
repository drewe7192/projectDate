//
//  FaceTimeVIew.swift
//  projectDate
//
//  Created by DotZ3R0 on 4/4/23.
//

import SwiftUI
import HMSSDK

struct FacetimeView: View {
//    var hmsSDK = HMSSDK.build()
//    @State var isMuted: Bool = false
//    @State var videoIsShowing = true
//
//    @State var localTrack = HMSVideoTrack()
//    @State var friendTrack = HMSVideoTrack()
//
//    @StateObject var viewModel: ViewModel
//
//    let tokenProvider = TokenProvider()
//
//    var body: some View {
//        ZStack(alignment: .bottom){
//            VideoView(track: friendTrack)
//            VideoView(track: localTrack)
//                .frame(width: 150, height: 250, alignment: .center)
//                .padding()
//
//            videoOptions
//                .padding(.bottom, 10)
//        }
//        .onAppear(perform: {
//            listen()
//            joinRoom()
//        })
//
//    }
//
//    func listen() {
//        self.viewModel.addVideoView = {
//            track in
//            hmsSDK.localPeer?.localAudioTrack()?.setMute(false)
//            hmsSDK.localPeer?.localVideoTrack()?.startCapturing()
//            self.localTrack = hmsSDK.localPeer?.localVideoTrack() as! HMSVideoTrack
//            self.friendTrack = track
//        }
//
//        self.viewModel.removeVideoView = {
//            track in
//            self.friendTrack = track
//        }
//    }
//
//    func joinRoom() {
//        tokenProvider.getToken(for: "638d9e07aee54625da64dfe2", role: "host") { token, error in
//            if let error = error {
//
//            }else {
//                if let token = token {
//                    let config = HMSConfig(authToken: token)
//                    hmsSDK.join(config: config, delegate: self.viewModel)
//                }
//
//            }
//        }
//
//    }
//
//    var videoOptions: some View {
//        HStack(spacing: 20) {
//            Spacer()
//            Button{
//
//            } label: {
//                Image(systemName: videoIsShowing ? "video.fill" : "video.slash.fill")
//                    .frame(width: 60, height: 60, alignment: .center)
//                    .background(.white)
//                    .foregroundColor(.black)
//                    .clipShape(Circle())
//
//            }
//
//            Button{
//
//            } label: {
//                Image(systemName: "phone.down.fill")
//                    .frame(width: 60, height: 60, alignment: .center)
//                    .background(.red)
//                    .foregroundColor(.white)
//                    .clipShape(Circle())
//
//            }
//
//            Button{
//
//            } label: {
//                Image(systemName: isMuted ? "mic.slash.fill" : "mic.fill")
//                    .frame(width: 60, height: 60, alignment: .center)
//                    .background(.white)
//                    .foregroundColor(.black)
//                    .clipShape(Circle())
//
//            }
//
//
//            Spacer()
//        }
//
//    }
    
    @StateObject var videoSDK = VideoSDK()
    @State var isJoining = false
    @State var isLeaveRoom = false
    
    var body: some View {
        Group {
            if videoSDK.isJoined {
               // List {
                ForEach(videoSDK.tracks, id: \.self) { track in
                    VStack{
                        VideoView(track: track)
                            .frame(height: 300)
                        
                                    videoOptions()
                                        .padding(.bottom, 10)
                    }
                     
                    }
                    .onChange(of: isLeaveRoom) { _ in
                        if videoSDK.tracks.indices.contains(1) {
                            videoSDK.tracks.remove(at: 1)
                        }
                      //  videoSDK.leaveRoom()
                    }
                    .task(delayLeave)
              //  }
            }
            else if isJoining {
                ProgressView()
            }
            else {
                Text("Join")
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .onAppear() {
                        videoSDK.joinRoom()
                        isJoining.toggle()
                    }
            }
        }
        
        
    }
    private func videoOptions() -> some View {
        HStack(spacing: 20) {
            Spacer()
            Button{
                videoSDK.muteCamera()
            } label: {
                Image(systemName: videoSDK.videoIsShowing ? "video.fill" : "video.slash.fill")
                    .frame(width: 60, height: 60, alignment: .center)
                    .background(.white)
                    .foregroundColor(.black)
                    .clipShape(Circle())
                
            }
            
            Button{
                videoSDK.leaveRoom()
            } label: {
                Image(systemName: "phone.down.fill")
                    .frame(width: 60, height: 60, alignment: .center)
                    .background(.red)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                
            }
            
            Button{
                videoSDK.muteMic()
            } label: {
                Image(systemName: videoSDK.isMuted ? "mic.slash.fill" : "mic.fill")
                    .frame(width: 60, height: 60, alignment: .center)
                    .background(.white)
                    .foregroundColor(.black)
                    .clipShape(Circle())
                
            }
            
            
            Spacer()
        }
        
    }
    
    
    @Sendable private func delayLeave() async {
        try? await Task.sleep(nanoseconds: 7_500_000_000)
        isLeaveRoom = true
    }
}
