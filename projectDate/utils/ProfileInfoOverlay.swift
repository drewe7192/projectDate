//
//  ProfileInfoOverlay.swift
//  projectDate
//
//  Created by DotZ3R0 on 11/21/22.
//

import SwiftUI

struct ProfileInfoOverlay: View {
    var body: some View {
        GeometryReader{ geoReader in
            ZStack{
                Text("")
                    .frame(width: geoReader.size.width * 0.96, height: geoReader.size.height * 0.3)
                    .background(.gray)
                    .cornerRadius(geoReader.size.width * 0.09)
                    .shadow(radius: geoReader.size.width * 0.04, x: geoReader.size.width * 0.1, y: geoReader.size.height * 0.05)
                    .opacity(0.5)
                
                VStack(alignment: .leading){
//                    Text(participant.fullName)
//                        .font(.title)
//                        .bold()
//                        .foregroundColor(.white)
//                        .padding()
                    
                    ScrollView{
                        VStack{
                            Text("Bio")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exert")
                                .padding(.bottom)
                                .foregroundColor(.white)
                            
                            Divider()
                            
                            Text("Values")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exert")
                                .padding(.bottom)
                                .foregroundColor(.white)
                            
                            Divider()
                            
                            Text("About Me")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                            HStack{
                                VStack(alignment: .leading){
                                    HStack{
                                        Image(systemName: "heart")
                                        Text("Never married")
                                            .foregroundColor(.white)
                                    }
                                    
                                    Spacer()
                                    
                                    HStack{
                                        Image(systemName: "figure.and.child.holdinghands")
                                        Text("No Kids")
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                    
                                    HStack{
                                        Image(systemName: "figure.2.and.child.holdinghands")
                                        Text("Maybe")
                                            .foregroundColor(.white)
                                    }
                                }
                                VStack(alignment: .leading){
                                    HStack{
                                        Image(systemName: "graduationcap")
                                        Text("Bachelors Degree")
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                    
                                    HStack{
                                        Image(systemName: "tshirt")
                                        Text("Athletic/Fit")
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                    
                                    HStack{
                                        Image(systemName: "wineglass")
                                        Text("On occasion")
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            
                        }
                    }
                }
                .frame(width: geoReader.size.width * 0.9, height: geoReader.size.height * 0.3)
                
            }.position(x: geoReader.frame(in: .global).midX, y: geoReader.frame(in: .global).midY)
        }
    }
}

struct ProfileInfoOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInfoOverlay()
    }
}
