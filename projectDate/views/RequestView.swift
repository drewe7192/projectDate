//
//  RequestView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 5/23/25.
//

import SwiftUI

struct RequestView: View {
    @State private var showSheet: Bool = false
    @State private var timeRemaining = 5
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var delegate: AppDelegate
    @EnvironmentObject var videoViewModel: VideoViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.primaryColor
                    .ignoresSafeArea()
                
                VStack{
                    Text("\(delegate.requestByProfile.name)")
                        .bold()
                        .font(.system(size: 60))
                        .foregroundColor(Color("tertiaryColor"))
                    
                    Text(" Requested a BlindChat!")
                        .font(.system(size: 60))
                        .foregroundColor(Color("tertiaryColor"))
                    
                    Button(action: {
                        Task {
                            
                            let fcmToken = try await profileViewModel.GetFCMToken(userId: delegate.requestByProfile.userId)
                            _ = try await profileViewModel.callSendAcceptNotification(fcmToken: fcmToken)
                            
                            videoViewModel.roomCode = delegate.requestByProfile.roomCode
                            
                            profileViewModel.participantProfile = delegate.requestByProfile
                            
                            var videoConfig = VideoConfigModel (role: RoleType.guest, isScreenBlurred: true, isFullScreen: true)
                            
                            /// show sheet for 5 seconds then launch
                            self.showSheet = true
                            try await Task.sleep(for: .seconds(5))
                            
                            viewRouter.currentPage = .videoPage(videoConfig: videoConfig)
                        }
                    }) {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .stroke(Color("tertiaryColor"), lineWidth: 2)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.08)
                            .overlay {
                                Text("Accept")
                                    .foregroundColor(.white)
                                    .cornerRadius(40)
                            }
                    }
                    .padding(.bottom)
                    
                    Button(action: {
                        Task {
                            let fcmToken = try await profileViewModel.GetFCMToken(userId: delegate.requestByProfile.userId)
                            _ = try await profileViewModel.callSendDeclineNotification(fcmToken: fcmToken)
                            
                            viewRouter.currentPage = .homePage
                        }
                    }) {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .stroke(Color("tertiaryColor"), lineWidth: 2)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.08)
                            .overlay {
                                Text("Decline")
                                    .foregroundColor(.white)
                                    .cornerRadius(40)
                            }
                    }
                }
            }
            .onReceive(timer) { time in
                if self.showSheet {
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    }
                    else {
                        self.showSheet = false
                    }
                }
            }
            .sheet(isPresented: $showSheet) {
                ZStack {
                    Color.primaryColor
                        .ignoresSafeArea()
                    
                    VStack{
                        Text("Chat starts in")
                            .font(.system(size: 60))
                            .foregroundColor(Color("tertiaryColor"))
                        
                        Text("\(self.timeRemaining) seconds")
                            .bold()
                            .font(.system(size: 60))
                            .foregroundColor(Color("tertiaryColor"))
                    }
                }
            }
        }
    }
}

#Preview {
    RequestView()
        .environmentObject(AppDelegate())
}
