//
//  RequestView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 5/23/25.
//

import SwiftUI

struct RequestView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var delegate: AppDelegate
    @EnvironmentObject var videoViewModel: VideoViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            
            VStack{
                Text("\(delegate.requestByProfile.name)")
                    .bold()
                    .font(.system(size: 60))
                    .foregroundColor(.black)
                
                Text(" Requested a BlindDate!")
                    .font(.system(size: 60))
                    .foregroundColor(.black)
                
                Button(action: {
                    Task {
                        let fcmToken = try await profileViewModel.GetFCMToken(userId: delegate.requestByProfile.userId)
                        _ = try await profileViewModel.callSendAcceptNotification(fcmToken: fcmToken)
                        
                        videoViewModel.roomCode = delegate.requestByProfile.roomCode
                        
                        viewRouter.currentPage = .videoPage
                    }
                }) {
                    Text("Accept")
                        .foregroundColor(.white)
                        .frame(width: 350, height: 60)
                        .background(Color.mainGrey)
                        .cornerRadius(40)
                }
                
                Button(action: {
                    Task {
                        let fcmToken = try await profileViewModel.GetFCMToken(userId: delegate.requestByProfile.userId)
                        _ = try await profileViewModel.callSendDeclineNotification(fcmToken: fcmToken)
                        
                        viewRouter.currentPage = .homePage
                    }
                }) {
                    Text("Decline")
                        .foregroundColor(.white)
                        .frame(width: 350, height: 60)
                        .background(Color.mainGrey)
                        .cornerRadius(40)
                }
            }
        }
    }
}

#Preview {
    RequestView()
}
