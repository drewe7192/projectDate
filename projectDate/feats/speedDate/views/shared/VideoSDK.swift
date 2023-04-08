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
        let config = HMSConfig(userName:"John Doe", authToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ2ZXJzaW9uIjoyLCJ0eXBlIjoiYXBwIiwiYXBwX2RhdGEiOm51bGwsImFjY2Vzc19rZXkiOiI2MzhkOWM5OWE1MDJjZjdmZDk1NDk0MTEiLCJyb2xlIjoiaG9zdCIsInJvb21faWQiOiI2MzhkOWQxY2VhNGNlZDNlODc1OGJmYWQiLCJ1c2VyX2lkIjoiYWQyYmVlMWMtOGQ2MS00MmZkLWI0ZjktMDE0NjMyNGVmMjU4IiwiZXhwIjoxNjgwNzU3NzI3LCJqdGkiOiIxNTAwMDM0ZC04NzM3LTQ1MmQtOTk2ZC1lMmNmYmRkMTdiYjgiLCJpYXQiOjE2ODA2NzEzMjcsImlzcyI6IjYzOGQ5Yzk5YTUwMmNmN2ZkOTU0OTQwZiIsIm5iZiI6MTY4MDY3MTMyNywic3ViIjoiYXBpIn0.8uhqxp765vS5uy4NtBvTFrTPnS929ApVqz_kuH-kuHE")
        hmsSDK.join(config: config, delegate: self)
    }
    
    func leaveRoom(){
        hmsSDK.leave()
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
