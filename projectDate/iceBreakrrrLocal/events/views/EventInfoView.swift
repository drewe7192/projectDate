//
//  EventView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import SwiftUI

struct EventInfoView: View {
    let event: EventModel
    
    var body: some View {
        GeometryReader{ geoReader in
            ZStack{
                Color(.systemTeal)
                    .ignoresSafeArea()
                
                VStack(){
                    VStack(alignment: .leading){
                
                        
                        VStack{
                            Text("\(event.location)")
                                .font(.system(size: 20))
                                .padding(7)
                                .overlay(
                                    RoundedRectangle(cornerRadius:20)
                                        .stroke(.black, lineWidth: 2)
                                )
                        }
                        
                        Text("\(event.title)")
                            .font(.system(size: 55))
                        
                    }
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
               
                    HStack{
                        VStack(alignment: .leading){
                            Text("Time of Event")
                        
                            
                            
                            Text("\(event.eventDate)")
                                .font(.system(size: 30))
                                .bold()
                            
                            Text("3pm")
                                .font(.system(size: 20))
                        }
                        
                        Spacer()
                            .frame(width: 100)
                        
                        VStack(){
                            Text("Host")
                            
                            HStack{
                                ForEach(event.participants, id: \.!.id){ item in
                                    Text("AV")
                                        .foregroundColor(.black)
                                        .frame(width: 40, height: 40)
                                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                                }
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.bottom,10)
                    
                    VStack{
                        Text("Description")
                            .padding(.bottom,10)
                        
                        Text("fds  fsdfsd lfjsd fdskljfsld fsdklfds flkdsjfsd flksdnf dsklfsd fjdskalfjsdfds fksdjfklsd fskdlfds flkjsdf dsklfnds fdslkfjsdlk dsfkljs dfdsklf")
                    }
                    .foregroundColor(.white)
                    .padding(.bottom,50)
                    
                    HStack{
                        ZStack{
                            Text("")
                                .frame(width: 150,height: 80)
                                .padding(7)
                                .overlay(
                                    RoundedRectangle(cornerRadius:35)
                                        .stroke(.black, lineWidth: 2)
                                )
                            
                            Text("Join")
                                .font(.system(size: 30))
                        }
                        Spacer()
                            .frame(width: 40)
                        ZStack{
                            Text("")
                                .frame(width: 150,height: 80)
                                .padding(7)
                                .overlay(
                                    RoundedRectangle(cornerRadius:35)
                                        .stroke(.black, lineWidth: 2)
                                )
                            
                            Text("Share")
                                .font(.system(size: 30))
                        }
                       
                    }
                    .foregroundColor(.white)
                    .padding(.bottom,40)
                   
                     
                }
            
              
            }
            .position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY )
    
         
        }
    }
}

struct EventInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EventInfoView(event: MockService.eventsSampleData.first!)
    }
}
