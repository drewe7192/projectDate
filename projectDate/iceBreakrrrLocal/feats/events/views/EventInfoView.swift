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
                
                VStack{
                    headerSection(for: geoReader)
               
                    bodySection(for: geoReader)
                    
                    descriptionSection(for: geoReader)
                    
                    footerSection(for: geoReader)
                  
                }
            
            }
            .position(x: geoReader.frame(in: .local).midX, y: geoReader.frame(in: .local).midY )
        }
    }
    
    func headerSection(for geoReader: GeometryProxy) -> some View {
        VStack(alignment: .leading){
            VStack{
                Text("\(event.location)")
                    .font(.system(size: 15))
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
        .padding()
        
    }
    
    func bodySection(for geoReader: GeometryProxy) -> some View {
        
        HStack{
            VStack(alignment: .leading){
                Text("Time of Event")
                
                Text("\(event.eventDate.formatted(.dateTime.day().month().year()))")
                    .font(.system(size: 20))
                    .bold()
                
                Text("3pm")
                    .font(.system(size: 20))
            }
            
            Spacer()
            
            
            VStack(){
                Text("Guests")
                
                ZStack{
                    ForEach(event.participants, id: \.!.id){ item in
                        Text("AV")
                            .foregroundColor(.black)
                            .frame(width: 40, height: 40)
                            .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                    }
                    
                    Text("")
                        .background(.white)
                        .frame(width: 40, height: 40)
                        .overlay(Circle())
                        .offset(x:-20, y: 0)
                    
                    Text("+2")
                        .foregroundColor(.black)
                        .bold()
                        .frame(width: 40, height: 40)
                        .offset(x:-20, y: 0)
                }
            }
        }
        .foregroundColor(.white)
        .padding()
        
    }
    
    func descriptionSection(for geoReader: GeometryProxy) -> some View {
        
        VStack{
            Text("Description")
                .padding(.bottom,10)
            
            Text("fds  fsdfsd lfjsd fdskljfsld fsdklfds flkdsjfsd flksdnf dsklfsd fjdskalfjsdfds fksdjfklsd fskdlfds flkjsdf dsklfnds fdslkfjsdlk dsfkljs dfdsklf")
        }
        .foregroundColor(.white)
        .padding()
        
    }
    
    func footerSection(for geoReader: GeometryProxy) -> some View {
        HStack{
            ZStack{
                Text("")
                    .frame(width: 350,height: 80)
                    .padding(7)
                    .overlay(
                        RoundedRectangle(cornerRadius:35)
                            .stroke(.black, lineWidth: 2)
                    )
                
                Text("Join")
                    .font(.system(size: 30))
            }
        }
        .foregroundColor(.white)
        
    }
}

struct EventInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EventInfoView(event: MockService.eventsSampleData.first!)
    }
}
