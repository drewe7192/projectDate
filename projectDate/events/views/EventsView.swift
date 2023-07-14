//
//  EventHomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage

struct EventsView: View {
    @ObservedObject private var viewModel = EventViewModel()
    @StateObject private var liveViewModel = LiveViewModel()
    
    @State private var searchText: String = ""
    @State private var isJoining: Bool = false
    @State private var events: [EventModel] = []
    @State private var showHamburgerMenu: Bool = false
    
    private var db = Firestore.firestore()
    
    var body: some View {
        NavigationView{
            GeometryReader{geoReader in
                ZStack{
                    ZStack{
                        Color.mainBlack
                            .ignoresSafeArea()
                        
                        eventCardView(for: geoReader)
                            .position(x: geoReader.frame(in: .local).midX, y: geoReader.size.height * 0.68)
                            .disabled(self.showHamburgerMenu ? true : false)
                        
                        headerSection(for: geoReader)
                            .padding(.leading, geoReader.size.width * 0.25)
                            .padding(.top,10)
                    }
                    
                    //Display hamburgerMenu
                    if self.showHamburgerMenu {
                        MenuView(showHamburgerMenu: self.$showHamburgerMenu)
                            .frame(width: geoReader.size.width/2)
                            .padding(.trailing,geoReader.size.width * 0.5)
                    }
                }
                .ignoresSafeArea(edges: .top)
                .position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY )
                .onAppear{
                    getEvents()
                    liveViewModel.getUserProfile(){(profileId) -> Void in
                        if profileId != "" {
                            liveViewModel.getStorageFile(profileId: profileId)
                        }
                    }
                }
            }
        }
    }
    
    private func eventCardView(for geoReader: GeometryProxy) -> some View {
        VStack{
                Text("All Upcoming SpeedMeets")
                    .font(.system(size: geoReader.size.height * 0.05))
                    .bold()
                    .foregroundColor(.white)
            
            SearchInput(searchText: $searchText)
                .position(x: geoReader.size.width * 0.64, y: geoReader.size.height * 0.21)
            
            ScrollView{
                VStack{
                    // filter is used for the SearchInput() above this scrollView
                    ForEach(self.events.filter({searchText.isEmpty ? true : $0.title.contains(searchText)})) { event in
                        NavigationLink(destination: EventInfoView(event: event)){
                            ZStack{
                                Text("")
                                    .frame(width: geoReader.size.width * 0.9, height: geoReader.size.height * 0.2)
                                    .background(Color.mainGrey)
                                    .cornerRadius(40)

                                
                                VStack(alignment: .leading){
                             
                                    Image("animeGirl")
                                        .resizable()
                                        .frame(width: geoReader.size.width * 0.14, height: geoReader.size.width * 0.14)
                                        .background(.gray)
                                        .clipShape(Circle())
                                    
                                    Text("Xavier Peloski")
                                        .foregroundColor(.white)
                                        .font(.system(size: 25))
                                        .padding(.bottom,5)
                                    
                                    Text("\(event.eventDate.formatted(.dateTime.day().month().year()))")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                    
                                }
                                .padding(.trailing,170)
                            }
                            // .padding(.bottom,geoReader.size.height * 0.03)
                        }
                    }
                }
            }
            .padding(.top, -340)
        }
    }
    
    private func getEvents(){
        db.collection("events")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting events: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //                        print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                        if !data.isEmpty{
                            let timestamp = data["eventDate"] as? Timestamp
                            let date = timestamp?.dateValue()
                            
                            let event = EventModel(id: data["id"] as? String ?? "", title: data["title"] as? String ?? "", location: data["location"] as? String ?? "", description: data["description"] as? String ?? "", participants: data["participants"] as? [String] ?? [], eventDate: date ?? Date())
                            
                            self.events.append(event)
                            
                        }
                    }
                }
            }
    }
    
    private func headerSection(for geoReader: GeometryProxy) -> some View {
        ZStack{
            HStack{
                HStack{
                    Image("logo")
                        .resizable()
                        .frame(width: 40, height: 40)
                    
                    Text("iceBreakrrr")
                        .font(.custom("Georgia-BoldItalic", size: geoReader.size.height * 0.03))
                        .bold()
                        .foregroundColor(Color.iceBreakrrrBlue)
                }
                
                HStack{
                    NavigationLink(destination: NotificationsView(), label: {
                        ZStack{
                            Text("")
                                .cornerRadius(20)
                                .frame(width: 40, height: 40)
                                .background(Color.black.opacity(0.6))
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                            
                            Image(systemName: "bell")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fill)
                        }
                    })
                    
                    NavigationLink(destination: SettingsView()) {
                        if(!liveViewModel.profileImage.size.width.isZero){
                            ZStack{
                                Text("")
                                    .cornerRadius(20)
                                    .frame(width: 40, height: 40)
                                    .background(.black.opacity(0.2))
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                
                                Image(uiImage: liveViewModel.profileImage)
                                    .resizable()
                                    .cornerRadius(20)
                                    .frame(width: 30, height: 30)
                                    .background(.black.opacity(0.2))
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                            }
                        } else {
                            ZStack{
                                Text("")
                                    .cornerRadius(20)
                                    .frame(width: 40, height: 40)
                                    .background(.black.opacity(0.6))
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .cornerRadius(20)
                                    .frame(width: 20, height: 20)
                                    .background(Color.black.opacity(0.6))
                                    .foregroundColor(.white)
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
            }
            .position(x: geoReader.size.width * 0.32, y: geoReader.size.height * 0.08)
            
            Button(action: {
                withAnimation{
                    self.showHamburgerMenu.toggle()
                }
            }) {
                ZStack{
                    Text("")
                        .frame(width: 35, height: 35)
                        .background(Color.black.opacity(0.6))
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Rectangle())
                        .cornerRadius(10)
                    
                    Image(systemName: "line.3.horizontal.decrease")
                        .resizable()
                        .frame(width: 20, height: 10)
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fill)
                }
            }
            .position(x: geoReader.size.width * -0.13, y: geoReader.size.height * 0.08)
        }
    }
}

struct EventHomeView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
