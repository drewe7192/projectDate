//
//  LikesView.swift
//  projectDate
//
//  Created by dotZ3R0 on 11/9/22.
//

import SwiftUI

struct LikesView: View {
    var body: some View {
        NavigationView{
            ZStack{
                    CustomHeaderView()
                VStack{
                    HStack{
                        NavigationLink(destination: ProfileView(participant: MockService.profileSampleData)) {
                            Text("dater profile")
                        }.frame(width: 150, height: 180)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                        
                        NavigationLink(destination: ProfileView(participant: MockService.profileSampleData)){
                            Text("dater profile")
                        }.frame(width: 150, height: 180)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                        
                    }
                    
                    HStack{
                        NavigationLink(destination: ProfileView(participant: MockService.profileSampleData)) {
                            Text("dater profile")
                        }.frame(width: 150, height: 180)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                        
                        NavigationLink(destination: ProfileView(participant: MockService.profileSampleData)){
                            Text("dater profile")
                        }.frame(width: 150, height: 180)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                        
                    }
                    
                    HStack{
                        NavigationLink(destination: ProfileView(participant: MockService.profileSampleData)) {
                            Text("dater profile")
                        }.frame(width: 150, height: 180)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                        
                        NavigationLink(destination: ProfileView(participant: MockService.profileSampleData)){
                            Text("dater profile")
                        }.frame(width: 150, height: 180)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                        
                    }    
                }
               
            }
            .navigationTitle("Likes You")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}

struct LikesView_Previews: PreviewProvider {
    static var previews: some View {
        LikesView()
    }
}
