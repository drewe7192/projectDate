//
//  VideoSDK.swift
//  projectDate
//
//  Created by DotZ3R0 on 4/5/23.
//

import Foundation
import HMSSDK

class VideoManager: ObservableObject {
    let hmsSDK = HMSSDK.build()
    @Published var tracks = [HMSVideoTrack]()
    @Published var isJoined = false
    
    func joinRoom(roomCode: String) {
        hmsSDK.getAuthTokenByRoomCode(roomCode, completion: { authToken, args in
            let config = HMSConfig(userName:"John Doe", authToken: authToken ?? "")
            self.hmsSDK.join(config: config, delegate: self)
        } )
    }
    
    func leaveRoom() {
        self.hmsSDK.leave()
    }
}

extension VideoManager: HMSUpdateListener {
    func onPeerListUpdate(added: [HMSPeer], removed: [HMSPeer]) {
        
    }
    
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
