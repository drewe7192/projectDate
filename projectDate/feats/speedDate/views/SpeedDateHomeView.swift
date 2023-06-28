//
//  speedDateHomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 4/4/23.
//

import SwiftUI

struct SpeedDateHomeView: View {
    let viewModel: HomeViewModel
    let placeInLine: Int
    @Binding var timeRemainingSpeedDateHomeView: Int
    @Binding var isStartVideoNow: Bool
    @Binding var isTimeEnded: Bool
    
    @State private var showHamburgerMenu: Bool = false
    
    var body: some View {
            GeometryReader{ geoReader in
                ZStack{
                    Color.mainBlack
                        .ignoresSafeArea()
                    
                    if !viewModel.speedDates.isEmpty {
                        // role is Host if userProfileId isnt in the array of matchingProfilesId
                        if(!viewModel.speedDates.first!.matchProfileIds.contains(viewModel.userProfile.id)){
                            VStack{
                                Text("SpeedDate")
                                    .foregroundColor(.white)
                                    .font(.system(size: geoReader.size.height * 0.06))
                                    .padding(.trailing,geoReader.size.width * 0.3)
                                    .padding(.top,geoReader.size.width * 0.1)
                                
                                eventDateSection(for: geoReader)
                                
                                Spacer()
                                    .frame(height: 120)

                                buttonSection(for: geoReader)
                            }
                            
                            // roleType is guest if userProfile.Id is in matchingProfiles id
                        } else if(viewModel.speedDates.first!.matchProfileIds.contains(viewModel.userProfile.id)) {
                            VStack{
                                Text("SpeedDate")
                                    .foregroundColor(.white)
                                    .font(.system(size: geoReader.size.height * 0.06))
                                    .padding(.trailing,geoReader.size.width * 0.3)
                                    .padding(.top,geoReader.size.width * 0.1)
                                
                                eventDateSection(for: geoReader)
                                VStack{
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
                                }
                                .padding(.top)
                           
                                Spacer()
                                    .frame(height: 120)
                                
                                buttonSection(for: geoReader)
                            }
                        }
                    }
                    else {
                        Text("NO SPEED DATES")
                            .font(.system(size: 50))
                            .foregroundColor(Color.iceBreakrrrBlue)
                    }
                }
                .position(x: geoReader.frame(in: .local).midX, y: geoReader.frame(in: .local).midY)
            }
    }
    
    private func eventDateSection(for geoReader: GeometryProxy) -> some View {
        VStack{
            HStack{
                Image(systemName: "calendar.badge.clock")
                    .resizable()
                    .frame(width: geoReader.size.width * 0.15 ,height: geoReader.size.height * 0.06)
                    .foregroundColor(.white)
                VStack{
                    Text("\(viewModel.speedDates.first!.eventDate.formatted())")
                        .bold()
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
                .background(.white)
                .foregroundColor(.gray)
                .cornerRadius(geoReader.size.width * 0.15)
                .shadow(radius: geoReader.size.width * 0.05)
        }
    }
    
    private func buttonSection(for geoReader: GeometryProxy) -> some View {
        VStack{
            //button
            NavigationLink(destination: FacetimeView(homeViewModel: viewModel, launchJoinRoom: $isTimeEnded, hasPeerJoined: $isTimeEnded, lookForRoom: $isTimeEnded), label: {
                CountdownTimerView(timeRemaining: $timeRemainingSpeedDateHomeView,
                                   geoReader: geoReader,
                                   isStartNow: $isStartVideoNow,
                                   isTimeEnded: $isTimeEnded,
                                   speedDates: viewModel.speedDates
                )
            }).disabled(isStartVideoNow == true ? false: true)
        }
    }
    
    private func headerSection(for geoReader: GeometryProxy) -> some View {
        ZStack{
            HStack{
                Text("iceBreakrrr")
                    .font(.custom("Georgia-BoldItalic", size: geoReader.size.height * 0.03))
                    .bold()
                    .foregroundColor(Color.iceBreakrrrBlue)
                    .position(x: geoReader.size.width * 0.3, y: geoReader.size.height * 0.03)
                
                Image("logo")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .background(Color.mainBlack)
                    .position(x: geoReader.size.width * -0.35, y: geoReader.size.height * 0.03)
            }
            
            HStack{
//                Button(action: {
//                    withAnimation{
//                        self.showHamburgerMenu.toggle()
//                    }
//                }) {
//                    ZStack{
//                        Text("")
//                            .frame(width: 40, height: 40)
//                            .background(Color.black.opacity(0.2))
//                            .aspectRatio(contentMode: .fill)
//                            .clipShape(Rectangle())
//                            .cornerRadius(10)
//
//                        Image(systemName: "line.3.horizontal.decrease")
//                            .resizable()
//                            .frame(width: 20, height: 10)
//                            .foregroundColor(.white)
//                            .aspectRatio(contentMode: .fill)
//                    }
//                }
//                .position(x: geoReader.size.height * -0.08, y: geoReader.size.height * 0.03)
//
//                Spacer()
//                    .frame(width: geoReader.size.width * 0.55)
//
//                NavigationLink(destination: NotificationsView(), label: {
//                    ZStack{
//                        Text("")
//                            .cornerRadius(20)
//                            .frame(width: 40, height: 40)
//                            .background(Color.black.opacity(0.2))
//                            .aspectRatio(contentMode: .fill)
//                            .clipShape(Circle())
//
//                        Image(systemName: "bell")
//                            .resizable()
//                            .frame(width: 20, height: 20)
//                            .foregroundColor(.white)
//                            .aspectRatio(contentMode: .fill)
//                    }
//                })
                
                NavigationLink(destination: SettingsView()) {
                    if(!viewModel.profileImage.size.width.isZero){
                        ZStack{
                            Text("")
                                .cornerRadius(20)
                                .frame(width: 40, height: 40)
                                .background(.black.opacity(0.2))
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                            
                            Image(uiImage: viewModel.profileImage)
                                .resizable()
                                .cornerRadius(20)
                                .frame(width: 30, height: 30)
                                .background(.black.opacity(0.2))
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                        }
                    } else {
                        ZStack{
                            Text("")
                                .cornerRadius(20)
                                .frame(width: 40, height: 40)
                                .background(.black.opacity(0.2))
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                            
                            Image(systemName: "person.circle")
                                .resizable()
                                .cornerRadius(20)
                                .frame(width: 20, height: 20)
                                .background(Color.black.opacity(0.2))
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                        }
                    }
                }
            }
        }
    }
}

struct SpeedDateHomeView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{geo in
            VStack{
                SpeedDateHomeView(viewModel: HomeViewModel(), placeInLine: 0, timeRemainingSpeedDateHomeView: .constant(9), isStartVideoNow: .constant(false), isTimeEnded: .constant(false))
            }
            .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
        }
        
    }
}

