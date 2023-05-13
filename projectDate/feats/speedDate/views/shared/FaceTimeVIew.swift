//
//  FaceTimeVIew.swift
//  projectDate
//
//  Created by DotZ3R0 on 4/4/23.
//

import SwiftUI
import HMSSDK

struct FacetimeView: View {
    @StateObject var videoSDK = VideoSDK()
    @StateObject var videoViewModel = VideoViewModel()
    
    @State var isJoining = false
    @State var isLeaveRoom = false
    @State var localTrack = HMSVideoTrack()
    @State var friendTrack = HMSVideoTrack()
    // this may be a problem, your building this once in here and another timne in VideoSDK
    //var hmsSDK = HMSSDK.build()
    
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let homeViewModel: HomeViewModel
    
    var body: some View {
        GeometryReader { geoReader in
            VStack{
                Group {
                    if videoSDK.isJoined {
                        ForEach(Array(videoSDK.tracks.enumerated()), id: \.offset) {index, track in
                            VStack{
                                ZStack{
                                    VStack{
                                        VideoView(track: track)
                                            .frame(height: 300)
                
                                        videoOptions()
                                            .padding(.bottom, 10)
                                    }
                                 
                                    
                                    VStack{
                                        //Timer
                                        Text("Time")
                                            .font(.title2)
                                        
                                        Text("\(timeRemaining / 60) : \(timeRemaining % 60)")
                                            .font(.largeTitle)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 5)
                                            .background(.black.opacity(0.75))
                                            .clipShape(Capsule())
                                    }
                                    .position(x: geoReader.frame(in: .local).midX, y: geoReader.size.height * 0.65)
                                }
                            }
                        }
                        .onChange(of: isLeaveRoom) { _ in
                        }
                        //.task(delayLeave)
                        //  }
                        .onReceive(timer) { time in
                            if videoSDK.tracks.indices.contains(1) {
                                if timeRemaining > 0 {
                                    timeRemaining -= 1
                                } else if timeRemaining == 0 {
                                    if videoSDK.tracks.indices.contains(1) {
                                        videoSDK.tracks.remove(at: 1)
                                        timeRemaining = 100
                                    }
                                    //videoSDK.leaveRoom()
                                }
                            }
                           
                        }
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
                                listen()
                                videoSDK.joinRoom(viewModel: homeViewModel)
                                isJoining.toggle()
                            }
                    }
                }
            }
            .position(x: geoReader.frame(in: .local).midX, y: geoReader.frame(in: .local).midY)
            
            
        }
        
    }
    private func videoOptions() -> some View {
        HStack(spacing: 20) {
            Spacer()
            Button{
                videoSDK.muteCamera()
            } label: {
                Image(systemName: videoSDK.videoIsShowing ? "video.fill" : "video.slash.fill")
                    .frame(width: 40, height: 40, alignment: .center)
                    .background(.white)
                    .foregroundColor(.black)
                    .clipShape(Circle())
            }
            
            Button{
                videoSDK.leaveRoom()
            } label: {
                Image(systemName: "phone.down.fill")
                    .frame(width: 40, height: 40, alignment: .center)
                    .background(.red)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
            
            Button{
                videoSDK.muteMic()
            } label: {
                Image(systemName: videoSDK.isMuted ? "mic.slash.fill" : "mic.fill")
                    .frame(width: 40, height: 40, alignment: .center)
                    .background(.white)
                    .foregroundColor(.black)
                    .clipShape(Circle())
            }
            Spacer()
        }
    }
    
    private func listen() {
        self.videoViewModel.addVideoView = {
            track in
            videoSDK.hmsSDK.localPeer?.localAudioTrack()?.setMute(false)
            self.localTrack = videoSDK.hmsSDK.localPeer?.localVideoTrack() as! HMSVideoTrack
            self.friendTrack = track
        }
        
        self.videoViewModel.removeVideoView = {
            track in
            self.friendTrack = track
        }
    }
    
    @Sendable private func delayLeave() async {
        try? await Task.sleep(nanoseconds: 7_500_000_000)
        isLeaveRoom = true
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
