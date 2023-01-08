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
                .padding(.top,400)

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
        VStack{
            NavigationLink(destination: RatingsView()) {
                Image(systemName: "star.bubble")
                    .resizable()
            }
            .frame(width: 35, height: 35)
            .foregroundColor(.white)
            .padding(.bottom,10)
            
            ZStack{
                Text("")
                    .frame(width: 45, height: 45)
                    .background(.white)
                    .cornerRadius(10)
                    .opacity(0.6)
                
                VStack{
                    Text("Height")
                        .font(.system(size: 15))
                    Text(viewModel.person.info.sideBarInfo.height)
                        .bold()
                        .font(.system(size: 15))
                }
            }
            
            ZStack{
                Text("")
                    .frame(width: 45, height: 45)
                    .background(.white)
                    .cornerRadius(10)
                    .opacity(0.6)
                
                VStack{
                    Text("From")
                        .font(.system(size: 15))
                    
                    Text(viewModel.person.location)
                        .bold()
                        .font(.system(size: 15))
                }
            }
            
            ZStack{
                Text("")
                    .frame(width: 45, height: 45)
                    .background(.white)
                    .cornerRadius(10)
                    .opacity(0.6)
                
                VStack{
                    Text("Smoke")
                        .font(.system(size: 15))
                    
                    if(viewModel.person.info.sideBarInfo.isSmoke) {
                        Text("yes")
                            .bold()
                            .font(.system(size: 15))
                    } else {
                        Text("no")
                            .bold()
                            .font(.system(size: 15))
                    }
                 
                }
            }
            
            ZStack{
                Text("")
                    .frame(width: 45, height: 45)
                    .background(.white)
                    .cornerRadius(10)
                    .opacity(0.6)
                
                VStack{
                    Text("Kids")
                    if(viewModel.person.info.sideBarInfo.isKids){
                        Text("+1")
                            .bold()
                            .font(.system(size: 15))
                    }else{
                        Text("none")
                            .bold()
                            .font(.system(size: 15))
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
