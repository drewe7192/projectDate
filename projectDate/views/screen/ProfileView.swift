//
//  SwiftUIView.swift
//  DatingApp
//
//  Created by DotZ3R0 on 7/28/22.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView{
            VStack{
                AsyncImage(url: URL(string: "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg"))
                    .frame(width: 150, height: 150)
                    .background(Color.gray)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                    .offset(y: -100)
      
                Text("dotZ3R0")
                    .bold()
                    .offset(y: -100)
                    
                
             
                        NavigationLink(destination: PreviewProfileView()) {
                            Text("PreviewProfile")
                        }.frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                    NavigationLink(destination: EditProfileView()){
                        Text("Edit Profile")
                    }.frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                    
                    NavigationLink(destination: SettingsView()) {
                        Text("Settings")
                    }.frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                
            }
            
        }
    
    }
}

struct CircleImageView: View{
    var color: Color
    
    var body: some View{
        ZStack{
            Circle()
                .frame(width: 150, height: 150)
                .foregroundColor(color)
            Text("Profile Image")
                .foregroundColor(.white)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
