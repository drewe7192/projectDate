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
        ZStack{
            ImageSlider(person: participant)

            ProfileInfoOverlay(participant: participant)
                .padding(.top,500)
                

            VStack{
                HStack{
                    sideBar
                        .opacity(0.8)
                        .padding(.top,100)
                    
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
                    .padding(.bottom,450)
                }
            }
            .padding(.bottom,450)
        }
    }
    
    private var sideBar: some View {
        
        ZStack{
            Text("")
                .frame(width: 45, height: 200)
                .background(.gray)
                .cornerRadius(20)
                .padding(.leading,5)
                .opacity(0.6)
               
            
            VStack{
                NavigationLink(destination: RatingsView()) {
                    Image(systemName: "star.bubble")
                        .resizable()
                        .foregroundColor(.white)
                }
                .frame(width: 25, height: 25)
                .foregroundColor(.white)
                .padding(.leading,5)
                
                Text("Ratings")
                    .bold()
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .padding(.bottom,10)
                    .padding(.leading,5)
             
                
                ZStack{
    //                Text("")
    //                    .frame(width: 45, height: 45)
    //                    .background(.white)
    //                    .cornerRadius(10)
    //                    .opacity(0.6)
                    
                    VStack{
                        Image(systemName: "pencil.and.ruler")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding(.leading,5)
    //                    Text("Height")
    //                        .font(.system(size: 15))
                        Text(viewModel.person.info.sideBarInfo.height)
                            .bold()
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.bottom,10)
                            .padding(.leading,5)
                    }
                }
                
                ZStack{
    //                Text("")
    //                    .frame(width: 45, height: 45)
    //                    .background(.white)
    //                    .cornerRadius(10)
    //                    .opacity(0.6)
                    
                    VStack{
                        Image(systemName: "mappin")
                            .resizable()
                            .frame(width: 10, height: 25)
                            .foregroundColor(.white)
                            .padding(.leading,5)
                        
    //                    Text("From")
    //                        .font(.system(size: 15))
                        
                        Text("Tampa")
                            .bold()
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.bottom,10)
                            .padding(.leading,5)
                    }
                }
            }
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
