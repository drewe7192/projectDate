//
//  speedDateHomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 4/4/23.
//

import SwiftUI

struct SpeedDateHomeView: View {
    @State private var isStartNow: Bool = false
    
    let viewModel: HomeViewModel
    let placeInLine: Int
    let timeLeft: Int
    
    var body: some View {
        GeometryReader{geoReader in
            ZStack{
                Color.mainBlack
                    .ignoresSafeArea()
                // role is Host if userProfileId isnt in the array of matchingProfilesId
                if(!viewModel.speedDates.first!.matchProfileIds.contains(viewModel.userProfile.id)){
                    VStack{
                        headerSection(for: geoReader)
                        Divider()
                            .background(.white)
                        
                        Text("Your dates")
                            .bold()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .font(.custom("Superclarendon", size: geoReader.size.height * 0.030))
                        ImageGridView()
                        
                        
                        //                    Spacer()
                        //                        .frame(height: geoReader.size.height * 0.02)
                        
                        //                  participantsSection(for: geoReader)
                        //
                        //
                        //
                        //                  middleSection(for: geoReader)
                        //
                        //
                        //
                        Text("Till First Date:")
                            .bold()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .font(.custom("Superclarendon", size: geoReader.size.height * 0.030))
                        buttonSection(for: geoReader)
                        
                        
                    }
                    // roleType is guest if userProfile.Id is in matchingProfiles id
                } else if(viewModel.speedDates.first!.matchProfileIds.contains(viewModel.userProfile.id)) {
                    VStack{
                        headerSection(for: geoReader)
                        Divider()
                            .background(.white)
                        
                        Text("Your place in line")
                            .bold()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .font(.custom("Superclarendon", size: geoReader.size.height * 0.030))
                        
                        Text("\(self.placeInLine)")
                            .bold()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .font(.custom("Superclarendon", size: geoReader.size.height * 0.030))
                        
                        buttonSection(for: geoReader)
                    }
                    .onAppear{
                     
                        
                      
                    }
                }
                
            }
            .position(x: geoReader.frame(in: .local).midX, y: geoReader.frame(in: .local).midY)
        }
    }
    
    private func headerSection(for geoReader: GeometryProxy) -> some View {
        VStack{
            HStack{
                Image(systemName: "calendar.badge.clock")
                    .resizable()
                    .frame(width: geoReader.size.width * 0.15 ,height: geoReader.size.height * 0.06)
                    .foregroundColor(.white)
                VStack{
                    Text("Tuesday, May 18th")
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("10:00 - 12:00")
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private func participantsSection(for geoReader: GeometryProxy) ->  some View {
        VStack{
            HStack{
                Text("Participants")
                    .bold()
                    .font(.system(size: geoReader.size.width * 0.05))
                    .padding(.trailing)
                ZStack{
                    Text("")
                        .frame(width: geoReader.size.width * 0.09, height: geoReader.size.width * 0.09)
                        .background(.white)
                        .foregroundColor(.gray)
                        .cornerRadius(geoReader.size.width * 0.008)
                        .overlay(RoundedRectangle(cornerRadius: geoReader.size.width * 0.05)
                            .stroke(.white, lineWidth: geoReader.size.width * 0.003))
                    
                    Text("4")
                }
            }
            .padding(.trailing,geoReader.size.width * 0.45)
        }
    }
    
    private func middleSection(for geoReader: GeometryProxy) -> some View {
        ZStack{
            Text("")
                .frame(width: geoReader.size.width * 0.95, height: geoReader.size.width, alignment: .bottom)
                .background(.white)
                .foregroundColor(.gray)
                .cornerRadius(geoReader.size.width * 0.15)
                .shadow(radius: geoReader.size.width * 0.05)
        }
    }
    
    private func buttonSection(for geoReader: GeometryProxy) -> some View {
        VStack{
            //button
            NavigationLink(destination: FacetimeView(), label: {
                CountdownTimerView(timeRemaining: timeLeft,
                                   geoReader: geoReader,
                                   isStartNow: $isStartNow,
                                   speedDates: viewModel.speedDates
                )
                
            }).disabled(isStartNow == true ? false: true)
        }
    }
}

struct SpeedDateHomeView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{geo in
            VStack{
                SpeedDateHomeView(viewModel: HomeViewModel(), placeInLine: 0, timeLeft: 9)
            }
            .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
        }
        
    }
}

