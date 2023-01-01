//
//  UserProfileView.swift
//  projectDate
//
//  Created by DotZ3R0 on 11/21/22.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    
    @State private var showingSheet: Bool = false
    
    var body: some View {
        ZStack{
            ImageSlider(person: viewModel.person)
            
            ProfileInfoOverlay(person: viewModel.person)
                .padding(.top,600)
            
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
                                .frame(width: 37, height: 7)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.bottom,300)
                }
            }
            .padding(.bottom,450)
        }
    }
    
    private var sideBar: some View {
        VStack{
            NavigationLink(destination: RatingsView()) {
                Image(systemName: "star.circle")
                    .resizable()
                
            }
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
            .padding(.bottom,10)
            
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
        ProfileView()
    }
}
