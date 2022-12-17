//
//  FacetimeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/11/22.
//

import SwiftUI
import HMSSDK

struct FacetimeView: View {
    var hmsSDK = HMSSDK.build()
    @State var isMuted: Bool = false
    @State var videoIsShowing = true
    
    @State var localTrack = HMSVideoTrack()
    @State var friendTrack = HMSVideoTrack()
    
    @StateObject var viewModel: ViewModel
    
    let tokenProvider = TokenProvider()
    
    var body: some View {
        ZStack(alignment: .bottom){
            VideoView(track: friendTrack)
            VideoView(track: localTrack)
                .frame(width: 150, height: 250, alignment: .center)
                .padding()
            
            videoOptions
                .padding(.bottom, 10)
        }
        .onAppear(perform: {
            listen()
            joinRoom()
        })
 
    }
    
    func listen() {
        self.viewModel.addVideoView = {
            track in
            hmsSDK.localPeer?.localAudioTrack()?.setMute(false)
            hmsSDK.localPeer?.localVideoTrack()?.startCapturing()
            self.localTrack = hmsSDK.localPeer?.localVideoTrack() as! HMSVideoTrack
            self.friendTrack = track
        }
        
        self.viewModel.removeVideoView = {
            track in
            self.friendTrack = track
        }
    }
    
    func joinRoom() {
        tokenProvider.getToken(for: "638d9e07aee54625da64dfe2", role: "host") { token, error in
            if let error = error {
                
            }else {
                if let token = token {
                    let config = HMSConfig(authToken: token)
                    hmsSDK.join(config: config, delegate: self.viewModel)
                }
                
            }
        }
        
    }
    
    var videoOptions: some View {
        HStack(spacing: 20) {
            Spacer()
            Button{
                
            } label: {
                Image(systemName: videoIsShowing ? "video.fill" : "video.slash.fill")
                    .frame(width: 60, height: 60, alignment: .center)
                    .background(.white)
                    .foregroundColor(.black)
                    .clipShape(Circle())
                
            }
            
            Button{
                
            } label: {
                Image(systemName: "phone.down.fill")
                    .frame(width: 60, height: 60, alignment: .center)
                    .background(.red)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                
            }
            
            Button{
                
            } label: {
                Image(systemName: isMuted ? "mic.slash.fill" : "mic.fill")
                    .frame(width: 60, height: 60, alignment: .center)
                    .background(.white)
                    .foregroundColor(.black)
                    .clipShape(Circle())
                
            }
            
            
            Spacer()
        }
        
    }
}


extension FacetimeView {
    class ViewModel: ObservableObject, HMSUpdateListener{
        
        @Published var addVideoView: ((_ videoView: HMSVideoTrack) -> ())?
        @Published var removeVideoView: ((_ videoView: HMSVideoTrack) -> ())?
        
        
        func on(join room: HMSRoom) {
            
        }
        
        func on(room: HMSRoom, update: HMSRoomUpdate) {
            
        }
        
        func on(peer: HMSPeer, update: HMSPeerUpdate) {
            
        }
        
        func on(track: HMSTrack, update: HMSTrackUpdate, for peer: HMSPeer) {
            switch update {
            case .trackAdded:
                if let videoTrack = track as? HMSVideoTrack {
                    addVideoView?(videoTrack)
                }
            case .trackRemoved:
                if let videoTrack = track as? HMSVideoTrack {
                    removeVideoView?(videoTrack)
                }
            default:
                break
            }
        }
        
        func on(error: Error) {
            
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
}
