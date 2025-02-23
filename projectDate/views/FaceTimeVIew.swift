//
//  FaceTimeVIew.swift
//  projectDate
//
//  Created by DotZ3R0 on 4/4/23.
//

import SwiftUI
import HMSSDK

struct FacetimeView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var videoManager = VideoManager()
    @StateObject var videoViewModel = VideoViewModel()
    
    @State var isJoining = false
    @State var isLeaveRoom = false
    @State var localTrack = HMSVideoTrack()
    @State var friendTrack = HMSVideoTrack()
    @State private var timeRemaining = 60
    @State private var tapped: Bool = false
    @State private var tapped2: Bool = false
    @State private var tapped3: Bool = false
    @State private var isDirty: Bool = false
    @State private var isRemovePeersDirty: Bool = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let liveViewModel: LiveViewModel
    @Binding var launchJoinRoom: Bool
    @Binding var hasPeerJoined: Bool
    @Binding var lookForRoom: Bool
    
    var body: some View {
        GeometryReader { geoReader in
            if videoManager.isJoined {
                ZStack{
                    ForEach(Array(videoManager.tracks.enumerated().reversed()), id: \.offset) {index, track in
                        ZStack{
                            VideoView(track: track)
                                .frame(width: index == 0 ?
                                       videoManager.tracks.count == 2 ? geoReader.size.width * 0.3 : geoReader.size.width :
                                        geoReader.size.width,
                                       height: index == 0 ?
                                       videoManager.tracks.count == 2 ? geoReader.size.height * 0.3 : geoReader.size.height :
                                        geoReader.size.height)
                                .position(x: index == 0 ?
                                          videoManager.tracks.count == 2 ? geoReader.size.width * 0.75 : geoReader.frame(in: .local).midX :
                                            geoReader.frame(in: .local).midX,
                                          y: index == 0 ?
                                          videoManager.tracks.count == 2 ? geoReader.size.height * 0.3 :  geoReader.frame(in: .local).midY :
                                            geoReader.frame(in: .local).midY)
                            
                            if index == 0 && videoManager.tracks.count == 2 {
                                videoOptions(for: geoReader)
                            }
                        }
//                        .onReceive(timer) { time in
//                            if videoSDK.tracks.count == 2 {
//                                hasPeerJoined = true
//                                if timeRemaining > 0 {
//                                    timeRemaining -= 1
//                                } else if timeRemaining == 0 {
//                                    endActiveRoom() {(peersRemoved) -> Void in
//                                            if peersRemoved != "" {
//                                                viewRouter.currentPage = .speedDateEndedPage
//                                            }
//                                        }
//                                }
//                            }
//                        }
//                        .onChange(of: tapped2) {_ in
//                            if self.timeRemaining < 120 && !isDirty {
//                                self.timeRemaining += 120
//                                self.isDirty = true
//                            }
//                            
//                        }
                    }
                    
                    //SpeedDate Timer
                    if hasPeerJoined {
                        VStack{
                            Text("\(timeRemaining / 60):\(timeRemaining % 60)\(timeRemaining % 60 == 0 ? "0" : "" )")
                                .font(.custom("Superclarendon", size: geoReader.size.height * 0.08))
                                .foregroundColor(.iceBreakrrrBlue)
                                .padding(.horizontal, 20)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            else if isJoining {
                ProgressView()
            }
            else {
                Text("")
//                    .onChange(of: launchJoinRoom) { newValue in
//                        //listen()
//                        videoSDK.joinRoom(viewModel: liveViewModel)
//                        isJoining.toggle()
//                    }
            }
        }
    }
    private func videoOptions(for geoReader: GeometryProxy) -> some View {
        HStack(spacing: 20) {
            Spacer()
            
            VStack{
                Text("Reconnect")
                    .foregroundColor(Color.iceBreakrrrBlue)
                    .font(.system(size: 15))
                
                ZStack {
                    Circle()
                        .fill(tapped ? Color.iceBreakrrrBlue : .white)
                        .frame(width: 60, height: 60)
                        .shadow(color: .gray.opacity(0.5), radius: 10, x: 7, y: 7)
                        .opacity(hasPeerJoined ? 1 : 0.5)
                    Image(systemName: "app.connected.to.app.below.fill")
                        .foregroundColor(.black)
                        .font(.system(size: 30, weight: .semibold))
                    
                }
                .scaleEffect(tapped ? 0.95 : 1)
                .onTapGesture {
                    tapped.toggle()
                    
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                    //                        tapped = false
                    //                    }
                }
                .disabled(hasPeerJoined ? false: true)
            }
            
            VStack{
                Text("Extend Time")
                    .foregroundColor(Color.iceBreakrrrBlue)
                    .font(.system(size: 15))
                
                ZStack {
                    Circle()
                        .fill(tapped2 ? Color.iceBreakrrrBlue : .white)
                        .frame(width: 60, height: 60)
                        .shadow(color: .gray.opacity(0.5), radius: 10, x: 7, y: 7)
                        .opacity(hasPeerJoined ? 1 : 0.5)
                    Image(systemName: "timer")
                        .foregroundColor(.black)
                        .font(.system(size: 30, weight: .semibold))
                    
                }
                .scaleEffect(tapped2 ? 0.95 : 1)
                .onTapGesture {
                    tapped2.toggle()
                    
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                    //                        tapped2 = false
                    //                    }
                }
                .disabled(hasPeerJoined ? false: true)
            }
            
            VStack{
                Text("Dislike")
                    .foregroundColor(Color.iceBreakrrrBlue)
                    .font(.system(size: 15))
                
                ZStack {
                    Circle()
                        .fill(tapped3 ? .red : .white)
                        .frame(width: 60, height: 60)
                        .shadow(color: .gray.opacity(0.5), radius: 10, x: 7, y: 7)
                        .opacity(hasPeerJoined ? 1 : 0.5)
                    Image(systemName: "hand.thumbsdown")
                        .foregroundColor(.black)
                        .font(.system(size: 30, weight: .semibold))
                    
                }
                .scaleEffect(tapped3 ? 0.95 : 1)
                .onTapGesture {
                    tapped3.toggle()
                    
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                    //                        tapped3 = false
                    //                    }
                }
                .disabled(hasPeerJoined ? false: true)
            }
            
            Spacer()
        }
        .position(x: geoReader.frame(in: .local).midX, y: geoReader.size.height * 0.9)
    }
    
    private func listen() {
        self.videoViewModel.addVideoView = {
            track in
            videoManager.hmsSDK.localPeer?.localAudioTrack()?.setMute(false)
            self.localTrack = videoManager.hmsSDK.localPeer?.localVideoTrack() as! HMSVideoTrack
            self.friendTrack = track
        }
        
        self.videoViewModel.removeVideoView = {
            track in
            self.friendTrack = track
        }
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    private func endActiveRoom(completed: @escaping (_ peersRemoved: String) -> Void){
        guard let url = URL(string: "https://us-central1-projectdate-a365b.cloudfunctions.net/endActiveRoom?room_id=\(liveViewModel.currentSpeedDate.roomId)") else {
            fatalError("Missing URL") }
        
        let json: [String: Any] = [
            "reason": "SpeedDate has ended",
            "lock": false
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonData
        urlRequest.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if let error = error {
                print("Request error: ", error)
                completed("")
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let message = String(data:data, encoding: .utf8)
                        completed("session deactivated")
                    } catch let error {
                        completed("")
                        print("Error decoding: ", error)
                    }
                }
            }
            completed("")
        }
        dataTask.resume()
    }
}
