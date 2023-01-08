//
//  ProfileInfoOverlay.swift
//  projectDate
//
//  Created by DotZ3R0 on 11/21/22.
//

import SwiftUI

struct ProfileInfoOverlay: View {
    let participant: ProfileModel
    
    var body: some View {
        ZStack{
        
            VStack(alignment: .leading){
                Text(participant.fullName)
                        .font(.title)
                        .padding()
                
                ScrollView{
                    VStack{
                        Text("Bio")
                            .font(.title2)
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exert")
                            .padding(.bottom)
                        
                    Divider()
                        
                        Text("Values")
                            .font(.title2)
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exert")
                            .padding(.bottom)
                        
                        Divider()
                        
                        Text("About Me")
                            .font(.title2)
                            .padding(.bottom, 5)
                        HStack{
                            VStack(alignment: .leading){
                                HStack{
                                    Image(systemName: "heart")
                                    Text("Never married")
                                }
                                
                                Spacer()
                                
                                HStack{
                                    Image(systemName: "figure.and.child.holdinghands")
                                    Text("No Kids")
                                }
                                Spacer()
                                
                                HStack{
                                    Image(systemName: "figure.2.and.child.holdinghands")
                                    Text("Maybe")
                                }
                            }
                            VStack(alignment: .leading){
                                HStack{
                                    Image(systemName: "graduationcap")
                                    Text("Bachelors Degree")
                                }
                                Spacer()
                                
                                HStack{
                                    Image(systemName: "tshirt")
                                    Text("Athletic/Fit")
                                }
                                Spacer()
                                
                                HStack{
                                    Image(systemName: "wineglass")
                                    Text("On occasion")
                                }
                            }
                        }
                      
                    }
                   
                }
              
            }
            .frame(width: 350, height: 200)
            .background(.gray)
            .cornerRadius(40)
            .opacity(0.5)
            .padding()
            
        }
    }
}



struct ProfileInfoOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInfoOverlay(participant: MockService.profileSampleData)
    }
}
