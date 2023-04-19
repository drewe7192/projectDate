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

struct EventHomeView: View {
    @ObservedObject private var viewModel = EventViewModel()
    @StateObject private var homeViewModel = HomeViewModel()
    
    @State private var searchText: String = ""
    @State private var isJoining: Bool = false
    @State private var showMenu: Bool = false
    @State private var events: [EventModel] = []
    
    private var db = Firestore.firestore()
    
    var body: some View {
        NavigationView{
            GeometryReader{geoReader in
                ZStack{
                    Color.mainBlack
                        .ignoresSafeArea()
                    VStack{
                        eventCardView(for: geoReader)
                    }
                    .offset(x: self.showMenu ? geoReader.size.width/2 : 0)
                    .disabled(self.showMenu ? true : false)
                    
                    if self.showMenu {
                        MenuView()
                            .frame(width: geoReader.size.width/2)
                            .padding(.trailing,geoReader.size.width * 0.5)
                    }
                
                }
                .position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY)
                .onAppear{
                    getEvents()
                    homeViewModel.getUserProfile(){(profileId) -> Void in
                        if profileId != "" {
                            homeViewModel.getStorageFile(profileId: profileId)
                        }
                    }
                }
                .navigationBarItems(leading: (
                        headerSection(for: geoReader)
                            .padding(.leading, geoReader.size.width * 0.25)
                ))
            }
        }
    }
    
 private func eventCardView(for geoReader: GeometryProxy) -> some View {
        VStack{
            Text("Events")
                .font(.system(size: geoReader.size.height * 0.05))
                .bold()
                .foregroundColor(.white)
            
            SearchInput(searchText: $searchText)
            
            ScrollView{
                VStack{
                    // filter is used for the SearchInput() above this scrollView
                    ForEach(self.events.filter({searchText.isEmpty ? true : $0.title.contains(searchText)})) { event in
                        NavigationLink(destination: EventInfoView(event: event)){
                            ZStack{
                                    Text("")
                                        .frame(width: geoReader.size.width * 0.9, height: geoReader.size.height * 0.25)
                                        .background(Color.mainGrey)
                                        .cornerRadius(30)
                                
                                
                                VStack{
                                    VStack(spacing: 5){
                                        Text("\(event.eventDate.formatted(.dateTime.day().month().year()))")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                        
                                        Text("\(event.title)")
                                            .bold()
                                            .foregroundColor(.white)
                                            .font(.system(size: 25))
                                            .padding(10)
                                        
                                        VStack{
                                            Text("\(event.location)")
                                                .foregroundColor(.white)
                                                .font(.system(size: 15))
                                        }
                                    }
                                    
                                    HStack{
                                        HStack{
                                            Image(systemName: "person.2.fill")
                                                .resizable()
                                                .frame(width: 25,height: 15)
                                                .foregroundColor(.iceBreakrrrPink)
                                            
                                            Text("\(event.participants.count) guests")
                                                .foregroundColor(.black)
                                                .shadow(radius: 7, x: 2, y: 5)
                                                .font(.system(size:15))
                                        }
                                        
                                        Button(action: {
                                            if(event.participants.contains(Auth.auth().currentUser?.uid ?? "noId")){
                                                viewModel.updateEventParticipants(event: event, action: "remove")
                                                
                                            } else{
                                                viewModel.updateEventParticipants(event: event, action: "add")
                                            }
                                        }) {
                                            Text(event.participants.contains(Auth.auth().currentUser?.uid ?? "noId") ? "UnJoin" : "Join")
                                                .font(.system(size: 15))
                                        }
                                        .frame(width: 100,height: 35)
                                        .background(event.participants.contains(Auth.auth().currentUser?.uid ?? "noId") ? Color.iceBreakrrrPink : Color.mainGrey)
                                        .foregroundColor(.white)
                                        .cornerRadius(15)
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
            }.padding(.top, -270)
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
                Text("iceBreakrrr")
                    .font(.custom("Georgia-BoldItalic", size: geoReader.size.height * 0.03))
                    .bold()
                    .foregroundColor(Color.iceBreakrrrBlue)
                    .position(x: geoReader.size.width * 0.3, y: geoReader.size.height * 0.03)
            
            Image("logo")
                .resizable()
                .frame(width: 40, height: 40)
                .background(Color.mainBlack)
                .position(x: geoReader.size.width * -0.35, y: geoReader.size.height * 0.03)
            }
            
            HStack{
                Button(action: {
                    withAnimation{
                        self.showMenu.toggle()
                    }
                }) {
                    ZStack{
                        Text("")
                            .frame(width: 40, height: 40)
                            .background(Color.black.opacity(0.2))
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
                .position(x: geoReader.size.height * -0.08, y: geoReader.size.height * 0.03)

                Spacer()
                    .frame(width: geoReader.size.width * 0.55)
                
                NavigationLink(destination: NotificationsView(), label: {
                    ZStack{
                        Text("")
                            .cornerRadius(20)
                            .frame(width: 40, height: 40)
                            .background(Color.black.opacity(0.2))
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
                    if(!homeViewModel.profileImage.size.width.isZero){
                        ZStack{
                            Text("")
                                .cornerRadius(20)
                                .frame(width: 40, height: 40)
                                .background(.black.opacity(0.2))
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                            
                            Image(uiImage: homeViewModel.profileImage)
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
                                .background(.black.opacity(0.2))
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())

                            Image(systemName: "person.circle")
                                .resizable()
                                .cornerRadius(20)
                                .frame(width: 20, height: 20)
                                .background(Color.black.opacity(0.2))
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                        }
                    }
                }
                
                // Dating/Friend Toggle button
                // adding this back in future versions
                
                //            Toggle(isOn: $showFriendDisplay, label: {
                //
                //            })
                //            .padding(geoReader.size.width * 0.02)
                //            .toggleStyle(SwitchToggleStyle(tint: .white))
            }
        }
       
    }
}

struct EventHomeView_Previews: PreviewProvider {
    static var previews: some View {
        EventHomeView()
    }
}
