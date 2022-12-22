//
//  RatingsView.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/22/22.
//

import SwiftUI

struct RatingsView: View {
    var body: some View {
        ScrollView{
            VStack{
                VStack{
                    Image("animeGirl")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                    
                    Text("Jenni Benni")
                        .font(.system(size: 30))
           
                }
                .padding(.bottom, 10)
                
                VStack(alignment: .leading){
                    Text("Looks")
                        .font(.system(size: 30))
                    Text("does th fjdsfjsd fsdjkfds fdskf ")
                        .foregroundColor(.gray)

                    starsMini
                        .padding(.bottom, 10)
                }
                   
                    
                Divider()
                VStack(alignment: .leading){
                    Text("Personality")
                        .font(.system(size: 30))
                    Text("does th fjdsfjsd fsdjkfds fdskf ")
                        .foregroundColor(.gray)

                    starsMini
                        .padding(.bottom, 10)
                }
                    
                Divider()
              
                VStack(alignment: .leading){
                    Text("Would you take a 2nd Date?")
                        .font(.system(size: 30))
                    Text("does th fjdsfjsd fsdjkfds fdskf ")
                        .foregroundColor(.gray)
                    
                    HStack {
                  
                        HStack{
                            Image(systemName: "hand.thumbsup")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 70)
                            Text("Yes")
                                .font(.system(size: 20))
                        }
                        .padding(.trailing,130)
                      
                         
                        
                        HStack{
                            
                            Image(systemName: "hand.thumbsdown")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 70)
                            Text("No")
                                .font(.system(size: 20))
                        }
                        
                      
                    }
                }
                    
                
                VStack(alignment: .leading){
                    Text("Flakeness")
                        .font(.system(size: 30))
                    Text("does th fjdsfjsd fsdjkfds fdskf ")
                        .foregroundColor(.gray)

                    starsMini
                        .padding(.bottom, 10)
                }
            }
        }
    }
    
    private var stars: some View {
        
        HStack{
            ForEach(0..<5){ item in
                Image(systemName: "star")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
            }
        }
    }
    
    private var starsMini: some View {
        
        HStack{
            ForEach(0..<5){ item in
                Image(systemName: "star")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
            }
        }
    }
}

struct RatingsView_Previews: PreviewProvider {
    static var previews: some View {
        RatingsView()
    }
}
