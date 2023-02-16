//
//  EventHomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import SwiftUI

struct EventHomeView: View {
    @Binding var searchText: String
    @State private var isEditing = false
    
    @ObservedObject private var viewModel = EventViewModel()
    
    var body: some View {
        NavigationView{
            GeometryReader{geoReader in
                
                ZStack{
                    Color(.systemTeal)
                        .ignoresSafeArea()
                    
                    eventCardView(for: geoReader)
                }
            }
        }
    }
    
    func eventCardView(for geoReader: GeometryProxy) -> some View {
        VStack{
            Text("Events")
                .font(.system(size: 30))
                .bold()
            
            HStack {
                TextField("Search ...", text: $searchText)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .overlay(
                        HStack{
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            
                            if isEditing{
                                Button(action: {
                                    self.searchText = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        self.isEditing = true
                    }
                
                if isEditing {
                    Button(action: {
                        self.isEditing = false
                        self.searchText = ""
                        
                    }) {
                        Text("Cancel")
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
                }
            }
            
            ScrollView{
                VStack{
                    ForEach(viewModel.events) { event in
                        NavigationLink(destination: EventInfoView(event: event)){
                            ZStack{
                                VStack{
                                    Text("")
                                        .frame(width: geoReader.size.width * 0.9, height: geoReader.size.height * 0.25)
                                        .shadow(radius: 10)
                                        .overlay(RoundedRectangle(cornerRadius: geoReader.size.width * 0.1).stroke(.white, lineWidth: 6))
                                    
                                }
                                
                                VStack{
                                    VStack( spacing: 5){
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
                                                .foregroundColor(.black)
                                            
                                            Text("6 guests")
                                                .foregroundColor(.black)
                                        }
                                        
                                        Text("Join")
                                            .frame(width: 80,height: 25)
                                            .background(.white)
                                            .foregroundColor(.black)
                                            .cornerRadius(22)
                                            .padding(.leading,100)
                                    }
                                }
                              
                            }
                            .padding(.bottom,15)
                        }
                    }
                }
            }
            
        }
    }
}

struct EventHomeView_Previews: PreviewProvider {
    static var previews: some View {
        EventHomeView(searchText: .constant(""))
    }
}
