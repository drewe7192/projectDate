//
//  MessageHomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/31/23.
//

import SwiftUI

import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage
import UIKit

struct MessageHomeView: View {
    @ObservedObject var viewModel = MessageViewModel()
    @StateObject var homeViewModel = HomeViewModel()
    
    @State private var foo: [String] = ["","","::"]
    @State private var showMenu: Bool = false
    @State private var userProfile: ProfileModel = ProfileModel(id: "", fullName: "", location: "", gender: "Pick gender", matchDay: "Day", messageThreadIds: [], speedDateIds: [], fcmTokens: [], preferredGender: "", currentRoomId: "")
    @State private var messageThreads: [MessageThreadModel] = []
    @State private var showSheet = false
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var body: some View {
        NavigationView{
            GeometryReader{ geoReader in
                ZStack{
                    Color.mainBlack
                        .ignoresSafeArea()
                    
                    VStack(spacing: 1 ){
                        Text("DISABLED UNTIL YOU MEET a Friend")
                            .bold()
                            .foregroundColor(.gray)
                            .opacity(0.5)
                            .font(.system(size: 30))
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
                .onAppear {
                    getUserProfile(){(profileId) -> Void in
                        if profileId != "" {
                            homeViewModel.getStorageFile(profileId: profileId)
                            if viewModel.messageThreads.isEmpty {
                                viewModel.getMessageThreads()
                            }
                         
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
    
    private func messageCardView(for geoReader: GeometryProxy) -> some View {
        VStack{
            ZStack{
                Text("")
                    .frame(width: 400, height: 90)
                    .font(.title.bold())
                    .background(Color.mainGrey)
                    .foregroundColor(.gray)
                    .cornerRadius(geoReader.size.width * 0.5)
                
                HStack{
                    Image("animeGirl")
                        .resizable()
                        .frame(width: geoReader.size.width * 0.15, height: geoReader.size.width * 0.15)
                    .background(.gray)
                    .clipShape(Circle())
                    .padding()
                    
                    VStack(alignment: .leading){
                        Text("Bob Barron")
                            .foregroundColor(.white)
                        Text("Yo that b was tripping bro")
                            .foregroundColor(.gray)
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
//                Button(action: {
//                    withAnimation{
//                        self.showMenu.toggle()
//                    }
//                }) {
//                    ZStack{
//                        Text("")
//                            .frame(width: 40, height: 40)
//                            .background(Color.black.opacity(0.2))
//                            .aspectRatio(contentMode: .fill)
//                            .clipShape(Rectangle())
//                            .cornerRadius(10)
//
//                        Image(systemName: "line.3.horizontal.decrease")
//                            .resizable()
//                            .frame(width: 20, height: 10)
//                            .foregroundColor(.white)
//                            .aspectRatio(contentMode: .fill)
//                    }
//                }
//                .position(x: geoReader.size.height * -0.08, y: geoReader.size.height * 0.03)

                Spacer()
                    .frame(width: geoReader.size.width * 0.55)
                
//                NavigationLink(destination: NotificationsView(), label: {
//                    ZStack{
//                        Text("")
//                            .cornerRadius(20)
//                            .frame(width: 40, height: 40)
//                            .background(Color.black.opacity(0.2))
//                            .aspectRatio(contentMode: .fill)
//                            .clipShape(Circle())
//
//                        Image(systemName: "bell")
//                            .resizable()
//                            .frame(width: 20, height: 20)
//                            .foregroundColor(.white)
//                            .aspectRatio(contentMode: .fill)
//                    }
//                })
               
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
            }
        }
    }
    
    private func getUserProfile(completed: @escaping (_ profileId: String) -> Void){
        db.collection("profiles")
            .whereField("userId", isEqualTo: Auth.auth().currentUser?.uid as Any)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completed("")
                } else {
                    for document in querySnapshot!.documents {
                        //                        print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                        if !data.isEmpty{
                            self.userProfile = ProfileModel(id: data["id"] as? String ?? "", fullName: data["fullName"] as? String ?? "", location: data["location"] as? String ?? "", gender: data["gender"] as? String ?? "", matchDay: data["matchDay"] as? String ?? "", messageThreadIds: data["messageThreadIds"] as? [String] ?? [], speedDateIds: data["speedDateIds"] as? [String] ?? [], fcmTokens: data["fcmTokens"] as? [String] ?? [], preferredGender: data["preferredGender"] as? String ?? "",currentRoomId: data["currentRoomId"] as? String ?? "")
                        }
                    }
                    completed(self.userProfile.id)
                }
            }
    }
    
    private func getMessageThreads(completed: @escaping (_ messageThreads: [MessageThreadModel]) -> Void){
        db.collection("messageThreads")
            .whereField("id", in: userProfile.messageThreadIds)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting  messageThread documents: \(err)")
                    completed([])
                } else {
                    for document in querySnapshot!.documents {
                        //                        print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                        if !data.isEmpty{
                            let messageThread = MessageThreadModel(id: data["id"] as? String ?? "", profileId: data["profileId"] as? String ?? "", messageIds: data["messageIds"] as? [String] ?? [])
                            
                            messageThreads.append(messageThread)
                        }
                    }
                    completed(self.messageThreads)
                }
            }
    }
    
    private func createMessageThreads(completed: @escaping(_ createdMessageThreadId: String) -> Void){
        let id = UUID().uuidString
        let docData: [String: Any] = [
            "id": id,
            "profileId": "",
            "messageIds": []
        ]
        
        let docRef = db.collection("messageThreads").document(id)
        
        docRef.setData(docData) {error in
            if let error = error{
                print("Error creating new messageThread: \(error)")
                completed("")
            } else {
                print("Successfully created messageThread!")
                self.userProfile.id = id
                self.userProfile.fullName = Auth.auth().currentUser?.displayName ?? ""
                completed(self.userProfile.id)
            }
        }
    }
}

struct MessageHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MessageHomeView()
    }
}
