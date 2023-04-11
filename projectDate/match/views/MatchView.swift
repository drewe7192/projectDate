//
//  MatchView.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/9/23.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage
import UIKit

struct MatchView: View {
    
    init(){
        getUserProfile()
        getStorageFile()
        getMatchRecords()
    }
    
    @StateObject var viewModel = HomeViewModel()
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var userProfile: ProfileModel = ProfileModel(id: "", fullName: "", location: "", gender: "", matchDay: "", messageThreadIds: [])
    @State private var matchRecords: [MatchRecordModel] = []
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var body: some View {
        VStack{
            Text("Its a Match!")
            HStack{
                Image(uiImage: viewModel.profileImage)
                    .resizable()
                    .cornerRadius(50)
                    .frame(width: 100, height: 100)
                    .background(Color.black.opacity(0.2))
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                
                Image(uiImage: viewModel.profileImage)
                    .resizable()
                    .cornerRadius(50)
                    .frame(width: 100, height: 100)
                    .background(Color.black.opacity(0.2))
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            }
            
            Spacer()
                .frame(height: 50)
           
            Button(action: {
                viewRouter.currentPage = .homePage
            }) {
               Text("Return to Home")
                    .bold()
                    .frame(width: 300, height: 70)
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(radius: 8, x: 10, y:10)
            }
        }
        
    }
    
    private func getMatchRecords(){
        db.collection("matchRecords")
            .whereField("userProfilId", isEqualTo: self.userProfile.id)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //                        print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                            if !data.isEmpty{
                                let matchRecord = MatchRecordModel(id: data["id"] as? String ?? "", userProfileId: data["userProfileId"] as? String ?? "", matchProfileId: data["matchProfileId"] as? String ?? "")
                                
                                self.matchRecords.append(matchRecord)
                            }
                    }
                }
            }
    }
    
    private func getUserProfile(){
        db.collection("profiles")
            .whereField("userId", isEqualTo: Auth.auth().currentUser?.uid as Any)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //                        print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                            if !data.isEmpty{
                                self.userProfile = ProfileModel(id: data["id"] as? String ?? "", fullName: data["fullName"] as? String ?? "", location: data["location"] as? String ?? "", gender: data["gender"] as? String ?? "", matchDay: data["matchDay"] as? String ?? "", messageThreadIds: data["messageThreadIds"] as? [String] ?? [])
                            }
                    }
                }
            }
    }
    
    private func getStorageFile() {
        let imageRef = storage.reference().child("\(String(describing: Auth.auth().currentUser?.uid))"+"/images/image.jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imageRef.getData(maxSize: Int64(1 * 1024 * 1024)) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("Error getting file: ", error)
            } else {
                let image = UIImage(data: data!)
                viewModel.profileImage = image!
                
            }
        }
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView()
    }
}
