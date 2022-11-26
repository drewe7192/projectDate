//
//  UserProfileView.swift
//  projectDate
//
//  Created by Drew Sutherland on 11/21/22.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack{
            VStack{
                AsyncImage(url: URL(string: "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg")) { image in
                    image.resizable()
                        .overlay(ProfileInfoOverlay()
                            .padding(.top,600)
                        )
                        
                } placeholder: {
                    ProgressView()
                }
                .frame(width: .infinity, height: 900)
                .background(Color.gray)
                .clipShape(Rectangle())
            }
            
            VStack{
                Image(systemName: "message")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                Text("2")
                
                Image(systemName: "heart")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                
                Text("2")
                
                ZStack{
                    Text("")
                        .frame(width: 55, height: 55)
                        .background(.white)
                        .cornerRadius(10)
                        .opacity(0.6)
                    
                    
                    VStack{
                        Text("Height")
                            .font(.system(size: 15))
                        Text("5.5")
                            .bold()
                            .font(.system(size: 20))
                    }
                }
                .padding()
                
                ZStack{
                    Text("")
                        .frame(width: 55, height: 55)
                        .background(.white)
                        .cornerRadius(10)
                        .opacity(0.6)
                    
                    VStack{
                        Text("From")
                            .font(.system(size: 15))
                        
                        Text("Tampa")
                            .bold()
                            .font(.system(size: 15))
                    }
                }
                
                ZStack{
                    Text("")
                        .frame(width: 55, height: 55)
                        .background(.white)
                        .cornerRadius(10)
                        .opacity(0.6)
                    
                    VStack{
                        Text("Smoke")
                            .font(.system(size: 15))
                        
                        Text("no")
                            .bold()
                            .font(.system(size: 20))
                    }
                }
                
                ZStack{
                    Text("")
                        .frame(width: 55, height: 55)
                        .background(.white)
                        .cornerRadius(10)
                        .opacity(0.6)
                    
                    VStack{
                        Text("Kids")
                        Text("+1")
                            .bold()
                    }
                }
            }
            .padding(.trailing, 300)
            .padding(.bottom,200)
            
            Image(systemName: "ellipsis")
                .resizable()
                .frame(width: 37,height: 7)
                .padding(.bottom,700)
                .padding(.leading,270)
        }
 
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
