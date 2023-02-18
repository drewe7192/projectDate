//
//  EventHomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import SwiftUI

struct EventHomeView: View {
    @State var searchText: String = ""
    @State var isJoining: Bool = false 
    @ObservedObject private var viewModel = EventViewModel()
    @State var selected: [Int] = []
    
    var body: some View {
        NavigationView{
            GeometryReader{geoReader in
                ZStack{
                    Color.mainBlack
                        .ignoresSafeArea()
                    
                    eventCardView(for: geoReader)
                }.position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY)
            }
        }
    }
    
    func eventCardView(for geoReader: GeometryProxy) -> some View {
        VStack{
            Text("Events")
                .font(.system(size: geoReader.size.height * 0.05))
                .bold()
            
            SearchInput(searchText: $searchText)
            
            ScrollView{
                VStack{
                    // filter is used for the SearchInput() above this scrollView
                    ForEach(viewModel.events.filter({searchText.isEmpty ? true : $0.title.contains(searchText)})) { event in
                        NavigationLink(destination: EventInfoView(event: event, selected: $selected)){
                            ZStack{
                                VStack{
                                    Text("")
                                        .frame(width: geoReader.size.width * 0.9, height: geoReader.size.height * 0.25)
                                        .background(Color.mainGrey)
                                        .cornerRadius(30)
                                    //.overlay(RoundedRectangle(cornerRadius: geoReader.size.width * 0.1).stroke(.black, lineWidth: 6))
                                }
                                
                                VStack{
                                    VStack(spacing: 5){
                                        Text("\(event.eventDate.formatted(.dateTime.day().month().year()))")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                        
                                        
                                        Text("\(event.title)")
                                            .bold()
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                        
                                        VStack{
                                            Text("\(event.location)")
                                                .foregroundColor(.white)
                                                .font(.system(size: 15))
                                        }
                                    }
                                    
                                    HStack{
                                        HStack{
                                            Image(systemName: "person.2.fill")
                                                .foregroundColor(.iceBreakrrrPink)
                                            
                                            Text("\(event.participants.count) guests")
                                                .foregroundColor(.black)
                                                .shadow(radius: 7, x: 2, y: 5)
                                        }
                                        
                                        Button(action: {
                                            if(selected.contains(event.id)){
                                                if let index = selected.firstIndex(of: event.id) {
                                                    selected.remove(at: index)
                                                }
                                            } else{
                                                selected.append(event.id)
                                            }
                                            
    
                                        }) {
                                            Text(selected.contains(event.id) ? "UnJoin" : "Join")
                                        }
                                            .frame(width: 80,height: 25)
                                            .background(selected.contains(event.id) ? Color.iceBreakrrrPink : Color.mainGrey)
                                            .foregroundColor(.white)
                                            .cornerRadius(22)
                                            .padding(.leading,100)
                                            .shadow(radius: 5, x: 7, y: 10)
                                    }
                                }
                                .padding()
                            }
                            .padding(.bottom,geoReader.size.height * 0.03)
                        }
                    }
                }
            }.padding(.top, -300)
            
        }
    }
}

struct EventHomeView_Previews: PreviewProvider {
    static var previews: some View {
        EventHomeView()
    }
}
