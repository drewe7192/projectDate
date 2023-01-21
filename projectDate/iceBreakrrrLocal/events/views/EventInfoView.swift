//
//  EventView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import SwiftUI

struct EventInfoView: View {
    var body: some View {
        GeometryReader{ geoReader in
            VStack(){
                
                VStack(alignment: .leading){
                    HStack{
                        Text("")
                            .frame(width: 60, height: 60)
                            .background(.blue)
                            .clipShape(Circle())
                        
                        Spacer()
                            .frame(width: 230)
                        
                        Text("")
                            .frame(width: 60, height: 60)
                            .background(.blue)
                            .clipShape(Circle())
                    }
                    .padding(.bottom,30)
                    
                    VStack{
                        Text("Wharf Tampa")
                            .font(.system(size: 20))
                            .padding(7)
                            .overlay(
                                RoundedRectangle(cornerRadius:20)
                                    .stroke(.black, lineWidth: 2)
                            )
                    }
                    
                    Text("SpeedDate Kickball")
                        .font(.system(size: 60))
                    
                }
                .padding(.bottom, 40)
           
                HStack{
                    VStack(alignment: .leading){
                        Text("Time of Event")
                    
                        
                        
                        Text("3:00pm")
                            .font(.system(size: 40))
                            .bold()
                        
                        Text("Decemeber 25th, 2023")
                    }
                    
                    Spacer()
                        .frame(width: 100)
                    
                    VStack(){
                        Text("Host")
                        
                        HStack{
                            ForEach(0..<2){ item in
                                Text("AV")
                                    .foregroundColor(.black)
                                    .frame(width: 40, height: 40)
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                            }
                        }
                    }
                }
                .padding(.bottom,10)
                
                VStack{
                    Text("Description")
                        .padding(.bottom,10)
                    
                    Text("fds  fsdfsd lfjsd fdskljfsld fsdklfds flkdsjfsd flksdnf dsklfsd fjdskalfjsdfds fksdjfklsd fskdlfds flkjsdf dsklfnds fdslkfjsdlk dsfkljs dfdsklf")
                }
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
                .padding(.bottom,40)
               
                 
            }
            .position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY )
    
         
        }
    }
}

struct EventInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EventInfoView()
    }
}
