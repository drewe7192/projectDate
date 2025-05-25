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
//                    eventViewModel.isFullScreen = true
//                    viewRouter.currentPage = .homePage
                }) {
                    Text("Accept")
                        .foregroundColor(.white)
                        .frame(width: 350, height: 60)
                        .background(Color.mainGrey)
                        .cornerRadius(40)
                }
                
                Button(action: {
                    delegate.requestByProfile.roomCode = ""
                    viewRouter.currentPage = .homePage
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
