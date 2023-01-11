//
//  sdHomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 11/26/22.
//

import SwiftUI

struct sdHomeView: View {
    let displayType: String

    @StateObject var viewModel = sdViewModel()
    
    var body: some View {
        ZStack{
            Color("Grey")
                .ignoresSafeArea()
                hostDisplay
         
        }
     
    }
    
    private var info: some View {
        VStack{
            Text("Lorem Ipsum is simply dummy text")
                .multilineTextAlignment(.center)
                .padding(.top,20)
            
            
            Text("Dont forget to")
                .multilineTextAlignment(.center)
                .padding(.top,20)
            
            Text("Have Fun!")
                .fontWeight(.bold)
                .font(.system(size: 40))
        }
    }
    
    private var hostDisplay: some View {
        VStack{
            VStack{
                HStack{
                    Image(systemName: "calendar.badge.clock")
                        .resizable()
                        .frame(width: 40 ,height: 40)
                      VStack{
                        Text("Tuesday, May 18th")
                            .bold()
                        Text("10:00 - 12:00")
                    }
                }
                
              
            
            }
            .padding(.top,150)
            .padding(.bottom,10)
            
            Divider()
            
            VStack{
                HStack{
                    Text("Participants")
                        .bold()
                        .font(.system(size: 20))
                        .padding(.trailing)
                    ZStack{
                        Text("")
                            .frame(width: 40, height: 40)
                            .background(.white)
                            .foregroundColor(.gray)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 20)
                                .stroke(.white, lineWidth: 2))
                        
                        Text("4")
                    }
                }
                .padding(.trailing,200)
       
                ScrollView(.horizontal){
                    HStack{
                        ForEach(viewModel.sd.profiles){ participant in
                            NavigationLink(destination: ProfileView(participant: participant), label: {
                                sdCardView(participant: participant)
                                    .padding(.trailing, 5)
                            })
                          
                        }
                    }
                }
            }
            .padding()
            
           
            ZStack{
                Text("")
                    .frame(width: 400, height: 400, alignment: .bottom)
                    .background(.white)
                    .foregroundColor(.gray)
                    .cornerRadius(60)
                    .padding(.top,20)
                    .padding(.bottom,280)
                    .shadow(radius: 10)
                
                sdInfoCardView()
                    .padding(.bottom,300)
              
                    //button
                    NavigationLink(destination: FacetimeView(viewModel: .init(), sdvm: viewModel), label: {
                        CountdownTimerView(timeRemaining: 1000)
                          
                    })
                    .padding(.top,250)
            }
        }
    }
}

struct sdHomeView_Previews: PreviewProvider {
    static var previews: some View {
        sdHomeView(displayType: "host")
    }
}
