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
    
    @State var searchText: String = ""
    @State var isJoining: Bool = false
    @State var events: [EventModel] = []
    @State private var profileImage: UIImage? = UIImage()
    
    private var db = Firestore.firestore()
    
    var body: some View {
        NavigationView{
            GeometryReader{geoReader in
                ZStack{
                    Color.mainBlack
                        .ignoresSafeArea()
                    VStack{
                        headerSection(for: geoReader)
                        eventCardView(for: geoReader)
                    }
                
                }
                .position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY)
                .onAppear{
                    getEvents()
                }
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
            Text("iceBreakrrr")
                .font(.custom("Georgia-BoldItalic", size: 20))
                .bold()
                .foregroundColor(Color.iceBreakrrrBlue)
                .padding(.leading, geoReader.size.width * -0.02)
            
            NavigationLink(destination: SettingsView()) {
                //change this back
                if(self.profileImage == nil){
                    ZStack{
                        Text("")
                            .cornerRadius(20)
                            .frame(width: 40, height: 40)
                            .background(.black.opacity(0.2))
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .padding(.leading, geoReader.size.width * 0.8)
                        
                        Image(uiImage: self.profileImage!)
                            .resizable()
                            .cornerRadius(20)
                            .frame(width: 30, height: 30)
                            .background(.black.opacity(0.2))
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .padding(.leading, geoReader.size.width * 0.8)
                    }
                } else {
                    ZStack{
                        Text("")
                            .cornerRadius(20)
                            .frame(width: 40, height: 40)
                            .background(.black.opacity(0.2))
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .padding(.leading, geoReader.size.width * 0.8)
                        
                        Image(systemName: "person.circle")
                            .resizable()
                            .cornerRadius(20)
                            .frame(width: 20, height: 20)
                            .background(Color.black.opacity(0.2))
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .padding(.leading, geoReader.size.width * 0.8)
                        
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
            
            ZStack{
                Text("")
                    .cornerRadius(20)
                    .frame(width: 40, height: 40)
                    .background(Color.black.opacity(0.2))
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .padding(.leading, geoReader.size.width * 0.55)
                
                Image(systemName: "bell")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .aspectRatio(contentMode: .fill)
                    .padding(.leading, geoReader.size.width * 0.55)
                
            }
            
            ZStack{
                Text("")
                    .frame(width: 40, height: 40)
                    .background(Color.black.opacity(0.2))
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Rectangle())
                    .cornerRadius(10)
                    .padding(.leading, geoReader.size.width * -0.45)
                
                Image(systemName: "line.3.horizontal.decrease")
                    .resizable()
                    .frame(width: 20, height: 10)
                    .foregroundColor(.white)
                    .aspectRatio(contentMode: .fill)
                    .padding(.leading, geoReader.size.width * -0.425)
            }
        }
    }
}

struct EventHomeView_Previews: PreviewProvider {
    static var previews: some View {
        EventHomeView()
    }
}
