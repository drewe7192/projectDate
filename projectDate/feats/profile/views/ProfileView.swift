//
//  UserProfileView.swift
//  projectDate
//
//  Created by DotZ3R0 on 11/21/22.
//

import SwiftUI

struct ProfileView: View {
    let participant: ProfileModel
    @StateObject var viewModel = ProfileViewModel()
    
    var body: some View {
        GeometryReader{ geoReader in
            ZStack{
//                ImageSlider(person: participant)
                
                ProfileInfoOverlay(participant: participant)
                    .padding(.top, geoReader.size.height * 0.15)
                
                VStack{
                    HStack{
                        sideBar(for: geoReader)
                            .opacity(0.8)
                        
                        Spacer()
                        
                        Menu {
                            Button("Test1", action: function1)
                            Button("Test2", action: function2)
                            Button("Test3", action: function3)
                        } label: {
                            Label {
                                Text("")
                            } icon: {
                                Image(systemName: "ellipsis")
                                    .resizable()
                                    .frame(width: 27, height: 7)
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.bottom,geoReader.size.height * 0.6)
                    }
                }
                .padding(.bottom,geoReader.size.height * 0.3)
                
            }.position(x: geoReader.frame(in: .local).midX, y: geoReader.frame(in: .local).midY)
        }
    }
    
    private func sideBar(for geoReader: GeometryProxy) -> some View {
        
        ZStack{
            Text("")
                .frame(width: geoReader.size.width * 0.13, height: geoReader.size.height * 0.3)
                .background(.gray)
                .cornerRadius(20)
                .padding(.leading,5)
                .opacity(0.6)
            
//            VStack{
//                NavigationLink(destination: RatingsView()) {
//                    Image(systemName: "star.bubble")
//                        .resizable()
//                        .foregroundColor(.white)
//                }
//                .frame(width: 25, height: 25)
//                .foregroundColor(.white)
//                .padding(.leading,5)
//                
//                Text("Ratings")
//                    .bold()
//                    .foregroundColor(.white)
//                    .font(.system(size: 12))
//                    .padding(.bottom,10)
//                    .padding(.leading,5)
//                
//                ZStack{
//                    VStack{
//                        Image(systemName: "pencil.and.ruler")
//                            .resizable()
//                            .frame(width: 20, height: 20)
//                            .foregroundColor(.white)
//                            .padding(.leading,5)
//                        
//                        Text(viewModel.person.info.height)
//                            .bold()
//                            .foregroundColor(.white)
//                            .font(.system(size: 15))
//                            .padding(.bottom,10)
//                            .padding(.leading,5)
//                    }
//                }
//                
//                ZStack{
//                    VStack{
//                        Image(systemName: "mappin")
//                            .resizable()
//                            .frame(width: 10, height: 25)
//                            .foregroundColor(.white)
//                            .padding(.leading,5)
//                        
//                        Text("Tampa")
//                            .bold()
//                            .foregroundColor(.white)
//                            .font(.system(size: 15))
//                            .padding(.bottom,10)
//                            .padding(.leading,5)
//                    }
//                }
//            }
        }
        
    }
    
    func function1(){
        
    }
    
    func function2(){
        
    }
    
    func function3(){
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(participant: MockService.profileSampleData)
    }
}
