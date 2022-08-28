//
//  PreviewProfileView.swift
//  DatingApp
//
//  Created by DotZ3R0 on 7/30/22.
//

import SwiftUI


struct ImageOverlay: View{
    var body: some View{
        ZStack{
            VStack{
                Text("dotZ3R0")
                    .foregroundColor(.white)
                Text("FSU")
                    .foregroundColor(.white)
                Text("blah blah")
                    .foregroundColor(.white)
            }.offset(x: -120, y: 260)
       
        }
    }
}
struct PreviewProfileView: View {
    var body: some View {
        ScrollView{
                Spacer()
            AsyncImage(url: URL(string: "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg")) { image in
                image.resizable()
                    .overlay(ImageOverlay())
            } placeholder: {
                ProgressView()
            }
            .frame(width: 600, height: 600)
            .background(Color.gray)
            .clipShape(Rectangle())
       

            
           
            AsyncImage(url: URL(string: "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 600, height: 600)
            .background(Color.gray)
            .clipShape(Rectangle())

            AsyncImage(url: URL(string: "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 600, height: 600)
            .background(Color.gray)
            .clipShape(Rectangle())

            
            Section{
                Text("Basics")
                    .font(.subheadline)
                HStack{
                    Text("6'0")
                    Text("active")
                }
                HStack{
                    Text("Social")
                    Text("Man")
                }
             
                
            }
            AsyncImage(url: URL(string: "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 600, height: 600)
            .background(Color.gray)
            .clipShape(Rectangle())
            
            AsyncImage(url: URL(string: "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 600, height: 600)
            .background(Color.gray)
            .clipShape(Rectangle())

            
        }
    }
}

struct PreviewProfileView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewProfileView()
    }
}
