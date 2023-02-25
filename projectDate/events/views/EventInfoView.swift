//
//  EventView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import SwiftUI
import Firebase
//import FirebaseCore
//import FirebaseFirestore
//import FirebaseAuth
//import FirebaseFirestoreSwift
//import FirebaseStorage

struct EventInfoView: View {
    @ObservedObject private var viewModel = EventViewModel()
    let event: EventModel
    
    var body: some View {
        GeometryReader{ geoReader in
            ZStack{
                Color.mainBlack
                    .ignoresSafeArea()
                
                VStack{
                    headerSection(for: geoReader)
               
                    bodySection(for: geoReader)
                    
                    descriptionSection(for: geoReader)
                    
                    footerSection(for: geoReader)
                  
                }
            
            }.position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY )
            .position(x: geoReader.frame(in: .local).midX, y: geoReader.frame(in: .local).midY )
        }
    }
    
    func headerSection(for geoReader: GeometryProxy) -> some View {
        VStack(alignment: .leading){
            VStack{
                Text("\(event.location)")
                    .font(.system(size: 15))
                    .padding(7)
                    .background(Color.mainGrey)
                    .cornerRadius(39)
            }
            
            Text("\(event.title)")
                .foregroundColor(Color.iceBreakrrrBlue)
                .font(.system(size: 55))
            
        }
        .foregroundColor(.white)
        .padding()
        
    }
    
    func bodySection(for geoReader: GeometryProxy) -> some View {
        
        HStack{
            VStack(alignment: .leading){
                Text("Time of Event")
                    .foregroundColor(Color.iceBreakrrrBlue)
                
                Text("\(event.eventDate.formatted(.dateTime.day().month().year()))")
                    .font(.system(size: 20))
                    .bold()
                
                Text("3pm")
                    .font(.system(size: 20))
            }
            
            Spacer()
            
            
            VStack(){
                Text("Guests")
                    .foregroundColor(.iceBreakrrrBlue)
                
                ZStack{
                    ForEach(event.participants, id: \.self){ item in
                        Text("AV")
                            .foregroundColor(.black)
                            .frame(width: 40, height: 40)
                            .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                    }
                    
                    Text("")
                        .frame(width: 40, height: 40)
                        .overlay(Circle().foregroundColor(Color.white))
                        .offset(x:-20, y: 0)
                    
                    Text("+\(event.participants.count)")
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
                .foregroundColor(Color.iceBreakrrrBlue)
                .padding(.bottom,10)
            
            Text("fds  fsdfsd lfjsd fdskljfsld fsdklfds flkdsjfsd flksdnf dsklfsd fjdskalfjsdfds fksdjfklsd fskdlfds flkjsdf dsklfnds fdslkfjsdlk dsfkljs dfdsklf")
        }
        .foregroundColor(.white)
        .padding()
        
    }
    
    func footerSection(for geoReader: GeometryProxy) -> some View {
        HStack{
//            ZStack{
//                Text("")
//                    .frame(width: 350,height: 80)
//                    .padding(7)
//                    .overlay(
//                        RoundedRectangle(cornerRadius:35)
//                            .stroke(.black, lineWidth: 2)
//                    )
//
//                Text("Join")
//                    .font(.system(size: 30))
//            }
            
            // this button crashes the preview for some reason
            Button(action: {
                if(event.participants.contains(Auth.auth().currentUser!.uid)){
                    viewModel.updateEventParticipants(event: event, action: "remove")

                } else{
                    viewModel.updateEventParticipants(event: event, action: "add")
                }
            }) {
                Text(event.participants.contains(Auth.auth().currentUser!.uid) ? "UnJoin" : "Join")
                    .frame(width: 350,height: 80)
                    .padding(7)
                    .background(event.participants.contains(Auth.auth().currentUser!.uid) ? Color.iceBreakrrrPink : Color.mainGrey)
                    .cornerRadius(30)
                    .shadow(radius: 5, x: 4, y: 10)
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
