//
//  HomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/18/23.
//

import SwiftUI

struct LocalHomeView: View {
    @State private var showFriendDisplay = true
    @State private var downloadAmount = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView{
            GeometryReader{geoReader in
                ZStack{
                    Color("Gray")
                        .ignoresSafeArea()
                    VStack{
                        headerSection(for: geoReader)
                        Divider()
                  
                        
                            Text(showFriendDisplay ? "Friend Profile": "Dating Profile")
                                .bold()
                                .font(.system(size: 25))
                                .padding(.trailing,200)
                            
                        
                       
                        .padding(.leading,30)
                     
                         
                        
                        HStack {
                            ZStack{
                                Circle()
                                    .stroke(
                                        Color.pink.opacity(0.5),
                                        lineWidth: 5
                                    ).frame(width: 130, height: 130)
                                
                                Text("98%")
                                    .font(.system(size: 40))
                            }
                            
                            Spacer()
                                .frame(width: 40)
                                
                            VStack{
                                VStack(alignment: .leading){
                                    Text("Test: 100%")
                                    Rectangle()
                                        .stroke(.green, lineWidth: 3)
                                        .frame(width: 140, height: 1)
                                }
                                
                                VStack(alignment: .leading){
                                    Text("Test: 100%")
                                    Rectangle()
                                        .stroke(.green, lineWidth: 3)
                                        .frame(width: 140, height: 1)
                                }
                                
                                VStack(alignment: .leading){
                                    Text("Test: 100%")
                                    Rectangle()
                                        .stroke(.green, lineWidth: 3)
                                        .frame(width: 140, height: 1)
                                }
                            }
                       
                          
                            
                        }
                    
                
                        
                        cardsSection(for: geoReader)
                        
//                        eventSection(for: geoReader)
                        
                      
                      
                    }
                }.position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY )
            }
        }
       
    }
    
    private func headerSection(for geoReader: GeometryProxy) -> some View {
        ZStack{
          
                Text("Logo")
                    .bold()
                    .font(.system(size: 30))
            
         
                Toggle("", isOn: $showFriendDisplay)
                .padding(.trailing,10)
            
            
        }
    }
    
    private func eventSection(for geoReader: GeometryProxy) ->  some View {
        VStack{
            Text("Next Event")
                .bold()
                .font(.system(size: 30))
                .padding(.trailing,200)
            NavigationLink(destination: EventInfoView()){
                EventCardView()
            }
         
        }
    }
    
    private func cardsSection(for geoReader: GeometryProxy) -> some View {
        VStack{

            
//            ProgressView("Downloading...", value: downloadAmount, total: 100)
//                .frame(width: 350, height: 10)
//                .padding(8)
//                .background(Color.gray.opacity(0.25))
//                .tint(.red)
//                .cornerRadius(8)
//                .onReceive(timer) {_ in
//                    if downloadAmount < 100 {
//                        downloadAmount += 2
//                    }
//                }
            SwipeCardsView()
        }
    }
}

struct LocalHomeView_Previews: PreviewProvider {
    static var previews: some View {
        LocalHomeView()
    }
}
