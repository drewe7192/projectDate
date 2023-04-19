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
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var viewModel = HomeViewModel()
    @State private var userProfile: ProfileModel = ProfileModel(id: "", fullName: "", location: "", gender: "", matchDay: "", messageThreadIds: [])
    @State private var matchRecords: [MatchRecordModel] = []
    @State private var userProfileImage: UIImage = UIImage()
    
    @State private var matchProfileImage: UIImage = UIImage()
    @State private var match2ProfileImage: UIImage = UIImage()
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var body: some View {
        GeometryReader{ geoReader in
            ZStack{
                Color.mainBlack
                    .ignoresSafeArea()
                
                VStack{
                    Text("Its a Match!")
                    HStack{
                        Image(uiImage: self.userProfileImage)
                            .resizable()
                            .cornerRadius(50)
                            .frame(width: 100, height: 100)
                            .background(Color.black.opacity(0.2))
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                        
                        Image(uiImage: self.matchProfileImage)
                            .resizable()
                            .cornerRadius(50)
                            .frame(width: 100, height: 100)
                            .background(Color.black.opacity(0.2))
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                        
                        Image(uiImage: self.match2ProfileImage)
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
                .onAppear{
                    viewModel.getUserProfile(){(profileId) -> Void in
                        if profileId != "" {
                            viewModel.getStorageFile(profileId: profileId)
                            getMatchRecordsForThisWeek() {(matchRecords) -> Void in
                                if !matchRecords.isEmpty {
                                    //getProfiles(matchRecords: matchRecords)
                                    //            getStorageFile()
                                    updateMatchRecords(matchRecords: matchRecords)
                                }
                            }
                        }
                    }
                   
                }
            }
            .position(x: geoReader.frame(in: .local).midX, y: geoReader.frame(in: .local).midY)
        }
    }
    
    private func getMatchRecordsForThisWeek(completed: @escaping(_ matchRecords: [MatchRecordModel]) -> Void){
        
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month, .day], from: Date())
        
                //still gotta change these to a week!
                let start = calendar.date(from: components)!
                let end = calendar.date(byAdding: .day, value: 1, to: start)!
    
        db.collection("matchRecords")
            .whereField("userProfileId", isEqualTo: viewModel.userProfile.id)
            .whereField("createdDate", isGreaterThan: start)
            .whereField("createdDate", isLessThan: end)
            .whereField("isNew", isEqualTo: true)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //                        print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                        if !data.isEmpty{
                            let matchRecord = MatchRecordModel(id: data["id"] as? String ?? "", userProfileId: data["userProfileId"] as? String ?? "", matchProfileId: data["matchProfileId"] as? String ?? "", cardIds: data["cardIds"] as? [String] ?? [], answers: data["answers"] as? [String] ?? [], isNew: data["isNew"] as? Bool ?? false)
                            
                            self.matchRecords.append(matchRecord)
                        }
                    }
                    completed(self.matchRecords)
                }
            }
    }
    
    public func updateMatchRecords(matchRecords: [MatchRecordModel]){
        for (randomMatch) in matchRecords {
            let id = UUID().uuidString
            
                let docData: [String: Any] = [
                    "isNew": false
                ]
                
            let docRef = db.collection("matchRecords").document(randomMatch.id)
                
                docRef.updateData(docData) {error in
                    if let error = error{
                        print("Error creating new card: \(error)")
                    } else {
                        print("Document successfully created Match record!")
                    }
                }
            
        }
    }
    
//    private func getProfiles(matchRecords: [MatchRecordModel]){
//
//
//        db.collection("profiles")
//            .whereField("id", isEqualTo: )
//            .getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        //                        print("\(document.documentID) => \(document.data())")
//                        let data = document.data()
//                        if !data.isEmpty{
//                            self.userProfile = ProfileModel(id: data["id"] as? String ?? "", fullName: data["fullName"] as? String ?? "", location: data["location"] as? String ?? "", gender: data["gender"] as? String ?? "", matchDay: data["matchDay"] as? String ?? "", messageThreadIds: data["messageThreadIds"] as? [String] ?? [])
//                        }
//                    }
//                }
//            }
//    }
    
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
        MatchView(viewModel: HomeViewModel())
    }
}
