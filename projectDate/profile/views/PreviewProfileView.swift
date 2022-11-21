//
//  PreviewProfileView.swift
//  DatingApp
//
//  Created by DotZ3R0 on 7/30/22.
//

import SwiftUI

struct PreviewProfileView: View {
    var body: some View {
        GeometryReader{geo in
            ScrollView{
                VStack{
                    let width = geo.size.width
                    let height = geo.size.height
                    
                    //Image
                    AsyncImage(url: URL(string: "https://i.pinimg.com/originals/01/c6/f4/01c6f460f860a0c5d6a6c22d01716951.jpg")) { image in
                        image.resizable()
                            .overlay(ImageOverlay())
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: width, height: height)
                    .background(Color.gray)
                    .clipShape(Rectangle())
//
                    //Info
                    InfoSection(geo: geo)
                        .padding()
                }
            }
        }
    }
}

struct AboutMeSection: View{
    let geo: GeometryProxy
    
    var body: some View{
        VStack(alignment: .leading){
            let width = geo.size.width
            let height = geo.size.height
            
            Text("About")
                .aspectRatio(contentMode: .fit)
                .frame(width: width/4 , height: height/24)
                .background(Color.gray)
                .cornerRadius(65)
                .opacity(0.7)
            
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct InterestSection: View{
    let geo: GeometryProxy
    
    var body: some View{
        VStack(alignment: .leading){
            let width = geo.size.width
            let height = geo.size.height
            
            Text("Interest")
                .aspectRatio(contentMode: .fit)
                .frame(width: width/4, height: height/24)
                .background(Color.gray)
                .cornerRadius(15)
                .opacity(0.7)
            
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct NameAndAge: View{
    var body: some View{
        VStack{
            HStack{
                Text("Jane Doe")
                    .bold()
                    .font(.largeTitle)
                
                Text("25")
                    .font(.largeTitle)
                    .foregroundColor(Color.gray)
            }
            
            Text("Server at Olive Garden")
                .frame(alignment: .leading)
                .font(.system(size: 15))
        }
    }
}

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

struct InfoSection: View{
    let geo: GeometryProxy
    
    var body: some View {
            VStack(alignment: .leading, spacing: 50){
                let width = geo.size.width
                let height = geo.size.height
                
                HStack{
                    NameAndAge()
                    Spacer()
                    
                    Image("femenine")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: width/12,
                            height: height/12,
                            alignment: .center)
                }
                AboutMeSection(geo: geo)
                InterestSection(geo: geo)
            }
    }
}

struct PreviewProfileView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewProfileView()
    }
}
