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
    // this may be a problem, your building this once in here and another timne in VideoSDK
    //var hmsSDK = HMSSDK.build()
    
    @State private var timeRemaining = 200
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let homeViewModel: HomeViewModel
    
    var body: some View {
        GeometryReader { geoReader in
            VStack{
                Group {
                    if videoSDK.isJoined {
                        ZStack{
                            VStack{
                                ForEach(Array(videoSDK.tracks.enumerated()), id: \.offset) {index, track in
                                    VStack{
                                        VideoView(track: track)
                                            .frame(height: 300)
                                        
                                        videoOptions()
                                            .padding(.bottom, 10)
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
                                            //videoSDK.leaveRoom()
                                        }
                                    }
                                }
                            }
                            
                            VStack{
                                //Timer
                                Text("Time")
                                    .font(.title2)
                                
                                Text("\(timeRemaining / 60) : \(timeRemaining % 60)")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .background(.black.opacity(0.75))
                                    .clipShape(Capsule())
                            }
                            .position(x: geoReader.frame(in: .local).midX, y: geoReader.size.height * 0.65)
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
            //            Button{
            //                videoSDK.muteCamera()
            //            } label: {
            //                Image(systemName: videoSDK.videoIsShowing ? "video.fill" : "video.slash.fill")
            //                    .frame(width: 40, height: 40, alignment: .center)
            //                    .background(.white)
            //                    .foregroundColor(.black)
            //                    .clipShape(Circle())
            //            }
            //
            //            Button{
            //                videoSDK.leaveRoom()
            //            } label: {
            //                Image(systemName: "phone.down.fill")
            //                    .frame(width: 40, height: 40, alignment: .center)
            //                    .background(.red)
            //                    .foregroundColor(.white)
            //                    .clipShape(Circle())
            //            }
            
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
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    private func removePeers(completed: @escaping (_ peersRemoved: String) -> Void){
        guard let url = URL(string: "https://us-central1-projectdate-a365b.cloudfunctions.net/removePeers?room_Id=\(homeViewModel.speedDates.first!.roomId)") else {
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
                        print("This is the message")
                        print(message)
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
