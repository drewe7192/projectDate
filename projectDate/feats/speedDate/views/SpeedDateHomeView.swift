//
//  speedDateHomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 4/4/23.
//

import SwiftUI

struct SpeedDateHomeView: View {
    let displayType: String
    @StateObject var viewModel = speedDateViewModel()
    
    var body: some View {
        GeometryReader{geoReader in
            ZStack{
                Color.mainBlack
                    .ignoresSafeArea()
                if(displayType == "Host"){
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
                } else if(displayType == "Guest") {
                    
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
            
            ScrollView(.horizontal){
                HStack{
                    ForEach(viewModel.sd.profiles){ participant in
                        NavigationLink(destination: ProfileView(participant: participant), label: {
                            SpeedDateCardView(participant: participant)
                                .padding(.trailing, geoReader.size.width * 0.02)
                        })
                        
                    }
                }
            }
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
            
            SpeedDateInfoCardView()
        }
    }
    
    private func buttonSection(for geoReader: GeometryProxy) -> some View {
        VStack{
            //button
            NavigationLink(destination: FacetimeView(), label: {
                CountdownTimerView(timeRemaining: 1000, geoReader: geoReader)
                
            })
        }
    }
    
    private var info: some View {
        VStack{
            Text("Lorem Ipsum is simply dummy text")
                .multilineTextAlignment(.center)
                .padding(.top,20)
            
            
            Text("Dont forget to")
                .multilineTextAlignment(.center)
                .padding(.top,20)
            
            Text("Have Fun!")
                .fontWeight(.bold)
                .font(.system(size: 40))
        }
    }
}

struct SpeedDateHomeView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{geo in
            VStack{
                SpeedDateHomeView(displayType: "Host")
            }
            .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
        }
        
    }
}

