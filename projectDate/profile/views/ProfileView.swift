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
            ZStack{
                CustomHeaderView()
                VStack{
                    CircleImageView()
                    Buttons()
                }
          
            }
        }
    }
    
}

struct CircleImageView: View{
    var body: some View{
        VStack{
            AsyncImage(url: URL(string: "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg"))
                .frame(width: 200, height: 200)
                .background(Color.gray)
                .clipShape(Circle())
                .shadow(radius: 10)
                .overlay(Circle().stroke(Color.blue, lineWidth: 10))
                .offset(y: -100)
                .padding(.top,30)
                .padding(.bottom, 20)
            
            HStack{
                
                Text("dotZ3R0")
                    .bold()
                    .offset(y: -100)
                    .font(.system(size: 25))
                
                Text("25")
                    .bold()
                    .offset(y: -100)
                    .foregroundColor(Color.gray)
                    .font(.system(size: 25))
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}



struct Buttons: View {
    var body: some View{
        VStack{
            NavigationLink(destination: PreviewProfileView()) {
                Text("PreviewProfile")
            }.frame(width: 300, height: 60)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(30)
            
            NavigationLink(destination: EditProfileView()){
                Text("Edit Profile")
            }.frame(width: 300, height: 60)
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(30)
            
            
            NavigationLink(destination: SettingsView()) {
                Text("Settings")
            }.frame(width: 300, height: 60)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(30)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
