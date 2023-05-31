//
//  MatchView.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/9/23.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage
import UIKit

struct MatchView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var viewModel = HomeViewModel()
    
    @State private var userProfileImage: UIImage = UIImage()
    @State private var isNoMatches: Bool = false
    
    let storage = Storage.storage()
    
    var body: some View {
        GeometryReader{ geoReader in
            ZStack{
                Color.iceBreakrrrBlue
                    .ignoresSafeArea()
                
                VStack{
                    if !self.isNoMatches {
                        Text("SpeedDate Sunday!")
                            .foregroundColor(.white)
                            .bold()
                            .font(.custom("Chalkduster", size: geoReader.size.height * 0.05))
                            .multilineTextAlignment(.center)
                    } else {
                        Text("SpeedDate Sunday!")
                            .foregroundColor(.white)
                            .bold()
                            .font(.custom("Chalkduster", size: geoReader.size.height * 0.05))
                            .multilineTextAlignment(.center)
                        
                        Text("but no matches yet..")
                            .foregroundColor(.white)
                            .bold()
                            .font(.custom("Chalkduster", size: geoReader.size.height * 0.03))
                            .multilineTextAlignment(.center)
                    }
                    
                    
                    
                    Image(uiImage: viewModel.profileImage)
                        .resizable()
                        .cornerRadius(50)
                        .frame(width: 130, height: 130)
                        .background(Color.black.opacity(0.2))
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                    
                    Spacer()
                        .frame(height: 50)
                    
                    if !self.isNoMatches {
                        HStack{
                            if !viewModel.matchProfileImages.isEmpty {
                                ForEach(viewModel.matchProfileImages, id: \.self){ profileImage in
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .cornerRadius(50)
                                        .frame(width: 100, height: 100)
                                        .background(Color.black.opacity(0.2))
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                }
                            }
                        }
                        
                        Spacer()
                            .frame(height: 50)
                        
                        Button(action: {
                            viewModel.updateMatchRecords(matchRecords: viewModel.matchRecords)
                            viewRouter.currentPage = .scheduleSpeedDatePage
                        }) {
                            Text("Schedule SpeedDates")
                                .bold()
                                .frame(width: 300, height: 70)
                                .background(Color.mainGrey)
                                .foregroundColor(.iceBreakrrrBlue)
                                .font(.system(size: 24))
                                .cornerRadius(20)
                                .shadow(radius: 8, x: 10, y:10)
                        }
                    } else {
                        Text("swipe at least 5 cards a week to schedule Speed Dates")
                            .foregroundColor(.white)
                            .bold()
                            .font(.custom("Chalkduster", size: geoReader.size.height * 0.03))
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            // make empty record so user doesnt keep on routing to this screen
                            viewModel.saveMatchRecords(matches: [MatchRecordModel(id: "", userProfileId: viewModel.userProfile.id, matchProfileId: "", cardIds: [], answers: [], isNew: false)], isNew: false)
                            viewRouter.currentPage = .homePage
                        }) {
                            Text("Go Home")
                                .bold()
                                .frame(width: 300, height: 70)
                                .background(Color.mainGrey)
                                .foregroundColor(.iceBreakrrrBlue)
                                .font(.system(size: 24))
                                .cornerRadius(20)
                                .shadow(radius: 8, x: 10, y:10)
                        }
                    }
                }
                .onAppear{
                    viewModel.getUserProfile(){(profileId) -> Void in
                        if profileId != "" {
                            viewModel.getStorageFile(profileId: profileId)
                            viewModel.getMatchRecordsForPreviousWeek() {(matchRecordsPreviousWeek) -> Void in
                                if !matchRecordsPreviousWeek.isEmpty {
                                    viewModel.getProfiles(matchRecords: matchRecordsPreviousWeek) {(matchProfiles) -> Void in
                                        if !matchProfiles.isEmpty{
                                            viewModel.getMatchStorageFiles(matchProfiles: matchProfiles)
                                        }
                                    }
                                } else {
                                    self.isNoMatches.toggle()
                                }
                            }
                        }
                    }
                }
            }
            .position(x: geoReader.frame(in: .local).midX, y: geoReader.frame(in: .local).midY)
        }
    }
    
    @Sendable private func delayOnAppear() async {
        // Delay of 3.5 seconds (1 second = 1_000_000_000 nanoseconds)
        try? await Task.sleep(nanoseconds: 6_500_000_000)
    }
    
    
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(viewModel: HomeViewModel())
    }
}
