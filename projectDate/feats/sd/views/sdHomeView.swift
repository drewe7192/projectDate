//
//  sdHomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 11/26/22.
//

import SwiftUI

struct sdHomeView: View {
    let displayType: String
    
    var sizing: GeometryProxy
    @StateObject var viewModel = sdViewModel()
    
    var body: some View {
        GeometryReader{go in
            ZStack{
                Color("Grey")
                    .ignoresSafeArea()
                VStack{
                    VStack{
                        HStack{
                            Image(systemName: "calendar.badge.clock")
                                .resizable()
                                .frame(width: go.size.width * 0.15 ,height: go.size.height * 0.06)
                            VStack{
                                Text("Tuesday, May 18th")
                                    .bold()
                                Text("10:00 - 12:00")
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Divider()
                    
                    Spacer()
                    VStack{
                        HStack{
                            Text("Participants")
                                .bold()
                                .font(.system(size: go.size.width * 0.05))
                                .padding(.trailing)
                            ZStack{
                                Text("")
                                    .frame(width: go.size.width * 0.09, height: go.size.width * 0.09)
                                    .background(.white)
                                    .foregroundColor(.gray)
                                    .cornerRadius(go.size.width * 0.008)
                                    .overlay(RoundedRectangle(cornerRadius: go.size.width * 0.05)
                                        .stroke(.white, lineWidth: go.size.width * 0.003))
                                
                                Text("4")
                            }
                        }
                        .padding(.trailing,go.size.width * 0.45)
                        
                        ScrollView(.horizontal){
                            HStack{
                                ForEach(viewModel.sd.profiles){ participant in
                                    NavigationLink(destination: ProfileView(participant: participant), label: {
                                        sdCardView(participant: participant)
                                            .padding(.trailing, go.size.width * 0.02)
                                    })
                                    
                                }
                            }
                        }
                    }
                
                    Spacer()
                    ZStack{
                        Text("")
                            .frame(width: go.size.width * 0.95, height: go.size.width, alignment: .bottom)
                            .background(.white)
                            .foregroundColor(.gray)
                            .cornerRadius(go.size.width * 0.15)
                            .shadow(radius: go.size.width * 0.05)
                        
                        sdInfoCardView()
                    }
                    Spacer()
                    VStack{
                        //button
                        NavigationLink(destination: FacetimeView(viewModel: .init(), sdvm: viewModel), label: {
                            CountdownTimerView(timeRemaining: 1000, sizing: sizing)
                            
                        })
                    }
                }
            }
            .position(x: go.frame(in: .local).midX, y: go.frame(in: .local).midY)
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

struct sdHomeView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{geo in
            VStack{
                sdHomeView(displayType: "host", sizing: geo)
            }
            .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
        }
        
    }
}
