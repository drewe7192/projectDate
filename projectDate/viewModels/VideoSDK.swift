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
    
    func joinRoom() {
        let config = HMSConfig(userName:"John Doe", authToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ2ZXJzaW9uIjoyLCJ0eXBlIjoiYXBwIiwiYXBwX2RhdGEiOm51bGwsImFjY2Vzc19rZXkiOiI2MzhkOWM5OWE1MDJjZjdmZDk1NDk0MTEiLCJyb2xlIjoiZmVtYWxlIiwicm9vbV9pZCI6IjY0NmExYWE4M2FjNGIzMDE1YjQ5MGI5YyIsInVzZXJfaWQiOiIyYWE3N2FmZC01NThkLTQ5NTEtYTNmMC04ODJhN2QxMzJhMDUiLCJleHAiOjE3NDAyNDc3MjksImp0aSI6Ijc2ZWI4MGMyLTIxYjMtNDQ5Ny05NzZjLTdjM2ZkNzFiNzQ3MiIsImlhdCI6MTc0MDE2MTMyOSwiaXNzIjoiNjM4ZDljOTlhNTAyY2Y3ZmQ5NTQ5NDBmIiwibmJmIjoxNzQwMTYxMzI5LCJzdWIiOiJhcGkifQ.wCcHMiSKugpjro-tT9vF-LRgidTjRi83R28BfQBNmjY")
        hmsSDK.join(config: config, delegate: self)
    }
}

extension VideoSDK: HMSUpdateListener {
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
