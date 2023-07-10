//
//  CircularProgressView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/21/23.
//

import SwiftUI

struct DiscoverView: View {
    @State private var showHamburgerMenu: Bool = false
    @ObservedObject private var viewModel = LiveViewModel()
    
    var body: some View {
        GeometryReader{ geoReader in
            ZStack{
                ZStack{
                    Color.mainBlack
                        .ignoresSafeArea()
                   
                    VStack{
                        Text("Discover")
                            .font(.system(size: geoReader.size.height * 0.05))
                            .bold()
                            .foregroundColor(.white)
                        
                        Spacer()
                            .frame(height: 40)
                        
                        Text("1v1")
                            .font(.system(size: geoReader.size.height * 0.05))
                            .foregroundColor(.white)
                        
                        ScrollView{
                            ForEach(0..<4, id: \.self) { item in
                                Text("sfdfsd")
                                    .bold()
                                    .frame(width: 400, height: 100)
                                    .background(Color.mainGrey)
                                    .foregroundColor(.iceBreakrrrBlue)
                                    .font(.system(size: 24))
                                    .cornerRadius(20)
                                    .shadow(radius: 8, x: 10, y:10)
                            }
                        }
                        .frame(height: 150)
                     
                        
                        VStack{
                            Text("Groups")
                                .font(.system(size: geoReader.size.height * 0.05))
                                .foregroundColor(.white)
                            
                            ScrollView{
                                ForEach(0..<4, id: \.self) { item in
                                    Text("sfdfsd")
                                        .bold()
                                        .frame(width: 400, height: 100)
                                        .background(Color.mainGrey)
                                        .foregroundColor(.iceBreakrrrBlue)
                                        .font(.system(size: 24))
                                        .cornerRadius(20)
                                        .shadow(radius: 8, x: 10, y:10)
                                }
                                
                            }
                         
                        }
                    }
                    .padding(.top,130)
                   
                    
                    
                    
                    
                    headerSection(for: geoReader)
                        .padding(.leading, geoReader.size.width * 0.25)
                        .padding(.top,10)
                }
                
                
                //Display hamburgerMenu
                if self.showHamburgerMenu {
                    MenuView(showHamburgerMenu: self.$showHamburgerMenu)
                        .frame(width: geoReader.size.width/2)
                        .padding(.trailing,geoReader.size.width * 0.5)
                }
                
            }
            .ignoresSafeArea(edges: .top)
            .position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY )
        }
     
      
      
    }
    
    
    private func headerSection(for geoReader: GeometryProxy) -> some View {
        ZStack{
            HStack{
                HStack{
                    Image("logo")
                        .resizable()
                        .frame(width: 40, height: 40)
                    
                    Text("iceBreakrrr")
                        .font(.custom("Georgia-BoldItalic", size: geoReader.size.height * 0.03))
                        .bold()
                        .foregroundColor(Color.iceBreakrrrBlue)
                }
                
                HStack{
                    NavigationLink(destination: NotificationsView(), label: {
                        ZStack{
                            Text("")
                                .cornerRadius(20)
                                .frame(width: 40, height: 40)
                                .background(Color.black.opacity(0.6))
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                            
                            Image(systemName: "bell")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fill)
                        }
                    })
                    
                    NavigationLink(destination: SettingsView()) {
                        if(!viewModel.profileImage.size.width.isZero){
                            ZStack{
                                Text("")
                                    .cornerRadius(20)
                                    .frame(width: 40, height: 40)
                                    .background(.black.opacity(0.2))
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                
                                Image(uiImage: viewModel.profileImage)
                                    .resizable()
                                    .cornerRadius(20)
                                    .frame(width: 30, height: 30)
                                    .background(.black.opacity(0.2))
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                            }
                        } else {
                            ZStack{
                                Text("")
                                    .cornerRadius(20)
                                    .frame(width: 40, height: 40)
                                    .background(.black.opacity(0.6))
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .cornerRadius(20)
                                    .frame(width: 20, height: 20)
                                    .background(Color.black.opacity(0.6))
                                    .foregroundColor(.white)
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
            } 
            .position(x: geoReader.size.width * 0.32, y: geoReader.size.height * 0.08)
            
            Button(action: {
                withAnimation{
                    self.showHamburgerMenu.toggle()
                }
            }) {
                ZStack{
                    Text("")
                        .frame(width: 35, height: 35)
                        .background(Color.black.opacity(0.6))
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Rectangle())
                        .cornerRadius(10)
                    
                    Image(systemName: "line.3.horizontal.decrease")
                        .resizable()
                        .frame(width: 20, height: 10)
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fill)
                }
            }
            .position(x: geoReader.size.width * -0.13, y: geoReader.size.height * 0.08)
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
