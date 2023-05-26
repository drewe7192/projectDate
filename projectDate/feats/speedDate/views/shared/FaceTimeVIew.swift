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
    @StateObject var videoSDK = VideoSDK()
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
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let homeViewModel: HomeViewModel
    @Binding var launchJoinRoom: Bool
    @Binding var hasPeerJoined: Bool
    
    var body: some View {
        GeometryReader { geoReader in
            VStack{
                Group {
                    if videoSDK.isJoined {
                        ZStack{
                            //Videos
                            VStack{
                                ForEach(Array(videoSDK.tracks.enumerated()), id: \.offset) {index, track in
                                    VStack{
                                        ZStack{
                                            if index == 1 {
                                                VideoView(track: track)
                                                    .frame(height: geoReader.size.height)
                                                    .onAppear{
                                                        //remove loading animated thingy
                                                        hasPeerJoined.toggle()
                                                    }
                                            }
                                            
                                            if index == 0 {
                                                VideoView(track: track)
                                                    .frame(width: hasPeerJoined ? geoReader.size.width * 0.3 : geoReader.size.width, height:  hasPeerJoined ? geoReader.size.height * 0.25 : geoReader.size.height)
                                                    .position(x: hasPeerJoined ?  geoReader.size.width * 0.8 : geoReader.frame(in: .local).midX,
                                                              y: hasPeerJoined ?  geoReader.size.height * 0.3 : geoReader.frame(in: .local).midY )
                                                    .animation(.default)
                                                
                                                videoOptions(for: geoReader)
                                                    .padding(.bottom, 10)
                                            }
                                        }
                                    }
                                }
                                .onReceive(timer) { time in
                                    if videoSDK.tracks.indices.contains(1) {
                                        if timeRemaining > 0 {
                                            timeRemaining -= 1
                                        } else if timeRemaining == 0 {
                                            removePeers() { (peersRemoved) -> Void in
                                                if peersRemoved != "" {
                                                    timeRemaining = 100
                                                }
                                            }
                                        }
                                    }
                                }
                                .onChange(of: tapped2) {_ in
                                    if self.timeRemaining < 120 && !isDirty {
                                        self.timeRemaining += 120
                                        self.isDirty = true
                                    }
                                    
                                }
                            }
                            
                            //SpeedDate Timer
                            if hasPeerJoined {
                                VStack{
                                    Text("\(timeRemaining / 60):\(timeRemaining % 60)")
                                        .font(.custom("Superclarendon", size: 60))
                                        .foregroundColor(.iceBreakrrrBlue)
                                        .padding(.horizontal, 20)
                                        .clipShape(Capsule())
                                }
                                .position(x: geoReader.frame(in: .local).midX, y: geoReader.size.height * 0.50)
                            }
                            
                        }
                    }
                    else if isJoining {
                        ProgressView()
                    }
                    else {
                        Text("")
                            .onChange(of: launchJoinRoom) { newValue in
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
            videoSDK.hmsSDK.localPeer?.localAudioTrack()?.setMute(false)
            self.localTrack = videoSDK.hmsSDK.localPeer?.localVideoTrack() as! HMSVideoTrack
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
    
    private func removePeers(completed: @escaping (_ peersRemoved: String) -> Void){
        guard let url = URL(string: "https://us-central1-projectdate-a365b.cloudfunctions.net/removePeers?room_id=\(homeViewModel.speedDates.first!.roomId)") else {
            fatalError("Missing URL") }
        
        let json: [String: Any] = [
            "role": "guest"
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
                    } catch let error {
                        completed("")
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
}
