//
//  MessageHomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/31/23.
//

import SwiftUI

struct MessageHomeView: View {
    @State private var foo: [String] = ["","","::"]
    @State private var profileImage: UIImage = UIImage()
    @State private var showMenu: Bool = false
    
    var body: some View {
        NavigationView{
            GeometryReader{ geoReader in
                ZStack{
                    Color.mainBlack
                        .ignoresSafeArea()
                    
                    VStack(spacing: 1 ){
                        ForEach(foo, id: \.self){ item in
                            NavigationLink(destination: MessageView()) {
                                
                                messageCardView(for: geoReader)
                            }
                        }
                    }
                }
                .navigationBarItems(leading: (
                        headerSection(for: geoReader)
                            .padding(.leading, geoReader.size.width * 0.25)
                ))
            }
        }
    }
    
    private func messageCardView(for geoReader: GeometryProxy) -> some View {
        VStack{
            ZStack{
                Text("")
                    .frame(width: 400, height: 90)
                    .font(.title.bold())
                    .background(Color.mainGrey)
                    .foregroundColor(.gray)
                    .cornerRadius(geoReader.size.width * 0.5)
                
                HStack{
                    Image("animeGirl")
                        .resizable()
                        .frame(width: geoReader.size.width * 0.15, height: geoReader.size.width * 0.15)
                    .background(.gray)
                    .clipShape(Circle())
                    .padding()
                    
                    VStack(alignment: .leading){
                        Text("Bob Barron")
                            .foregroundColor(.white)
                        Text("Yo that b was tripping bro")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
    
    private func headerSection(for geoReader: GeometryProxy) -> some View {
        ZStack{
            HStack{
                Text("iceBreakrrr")
                    .font(.custom("Georgia-BoldItalic", size: geoReader.size.height * 0.03))
                    .bold()
                    .foregroundColor(Color.iceBreakrrrBlue)
                    .position(x: geoReader.size.width * 0.3, y: geoReader.size.height * 0.03)
            
            Image("logo")
                .resizable()
                .frame(width: 40, height: 40)
                .background(Color.mainBlack)
                .position(x: geoReader.size.width * -0.35, y: geoReader.size.height * 0.03)
            }
            
            HStack{
                Button(action: {
                    withAnimation{
                        self.showMenu.toggle()
                    }
                }) {
                    ZStack{
                        Text("")
                            .frame(width: 40, height: 40)
                            .background(Color.black.opacity(0.2))
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
                .position(x: geoReader.size.height * -0.08, y: geoReader.size.height * 0.03)

                Spacer()
                    .frame(width: geoReader.size.width * 0.55)
                
                NavigationLink(destination: NotificationsView(), label: {
                    ZStack{
                        Text("")
                            .cornerRadius(20)
                            .frame(width: 40, height: 40)
                            .background(Color.black.opacity(0.2))
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
                    if(self.profileImage != nil){
                        ZStack{
                            Text("")
                                .cornerRadius(20)
                                .frame(width: 40, height: 40)
                                .background(.black.opacity(0.2))
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                            
                            Image(uiImage: self.profileImage)
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
                                .background(.black.opacity(0.2))
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())

                            Image(systemName: "person.circle")
                                .resizable()
                                .cornerRadius(20)
                                .frame(width: 20, height: 20)
                                .background(Color.black.opacity(0.2))
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                        }
                    }
                }
                
                // Dating/Friend Toggle button
                // adding this back in future versions
                
                //            Toggle(isOn: $showFriendDisplay, label: {
                //
                //            })
                //            .padding(geoReader.size.width * 0.02)
                //            .toggleStyle(SwitchToggleStyle(tint: .white))
            }
        }
       
    }
}

struct MessageHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MessageHomeView()
    }
}
