//
//  VideoSDK.swift
//  projectDate
//
//  Created by DotZ3R0 on 4/5/23.
//

import Foundation
import HMSSDK

class VideoSDK: ObservableObject {
    
    let hmsSDK = HMSSDK.build()
    @Published var tracks = [HMSVideoTrack]()
    @Published var isJoined = false
    @Published var isMuted = false
    @Published var videoIsShowing = true
    
    func joinRoom(viewModel: HomeViewModel ) {
        //guest
        if viewModel.speedDates.first!.matchProfileIds.contains(viewModel.userProfile.id) {
            hmsSDK.getAuthTokenByRoomCode("cer-erl-txy") { token, error in
                if let token = token {
                    let config = HMSConfig(userName: "Join Doe", authToken: token)
                    self.hmsSDK.join(config: config, delegate: self)
                }
            }
        } else{
            //host
            hmsSDK.getAuthTokenByRoomCode("mhb-ehw-kmz") { token, error in
                if let token = token {
                    let config = HMSConfig(userName: "Join Doe", authToken: token)
                    self.hmsSDK.join(config: config, delegate: self)
                }
            }
        }
    }
    
    func leaveRoom(){
        self.hmsSDK.leave()
    }
    
    func muteMic(){
        self.isMuted.toggle()
        self.hmsSDK.localPeer?.localAudioTrack()?.setMute(isMuted)
        
    }
    
    func muteCamera(){
        videoIsShowing.toggle()
        if videoIsShowing {
            self.hmsSDK.localPeer?.localVideoTrack()?.setMute(false)
        } else {
            self.hmsSDK.localPeer?.localVideoTrack()?.setMute(true)
        }
    }
}

extension VideoSDK: HMSUpdateListener {
    func on(join room: HMSRoom) {
        isJoined = true
    }
    
    func on(room: HMSRoom, update: HMSRoomUpdate) {
        
    }
    
    func on(peer: HMSPeer, update: HMSPeerUpdate) {
        switch update {
        case .peerLeft:
            if let videoTrack = peer.videoTrack {
                tracks.removeAll { $0 == videoTrack }
            }
        default:
            break
        }
    }
    
    func on(track: HMSTrack, update: HMSTrackUpdate, for peer: HMSPeer) {
        switch update {
        case .trackAdded:
            if let videoTrack = track as? HMSVideoTrack {
                tracks.append(videoTrack)
            }
        case .trackRemoved:
            if let videoTrack = track as? HMSVideoTrack {
                tracks.removeAll { $0 == videoTrack }
            }
        default:
            break
        }
    }
    
    func on(error: Error) {
        print(error.localizedDescription)
    }
    
    func on(message: HMSMessage) {
        
    }
    
    func on(updated speakers: [HMSSpeaker]) {
        
    }
    
    func onReconnecting() {
        
    }
    
    func onReconnected() {
        
    }
}
