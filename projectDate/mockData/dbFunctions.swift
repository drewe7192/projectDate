//
//  dbFunctions.swift
//  projectDate
//
//  Created by DotZ3R0 on 2/27/23.
//

import Foundation

import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage
import UIKit

//PLACE in Init HomeViewModel()
//getDocs() { (success) -> Void in
//    if !success.isEmpty {
//
//        self.deleteDocs(mostIds:success)
//    }
//}


//   @Published var idsToDelete: [String] = []


//public func deleteDocs(mostIds: [String]){
//    for iidd in mostIds {
//        db.collection("cards").document(iidd).delete() { err in
//            if let err = err {
//                print("Error removing document: \(err)")
//            } else {
//                print("Document successfully removed!")
//            }
//        }
//    }
//}
//
//public func getDocs(completed: @escaping (_ success: [String]) -> Void){
//    db.collection("cards")
//        .limit(to: 50)
//        .addSnapshotListener {(querySnapshot, error) in
//            guard let documents = querySnapshot?.documents
//            else{
//                print("No documents")
//                return completed([])
//            }
//            self.idsToDelete = documents.map { $0["id"]! as! String }
//            print("self.idsToDelete: \(self.idsToDelete)")
//            completed(self.idsToDelete)
//        }
//}






//Place this button in the HomeView() and use it to add and delete stuff. Cant put it in the HomeViewModel() init() becuase it'll run at least twice.. not sure why

//Button(action: {
////                                    viewModel.getDocs() { (success) -> Void in
////                                        if !success.isEmpty {
////
////                                            viewModel.deleteDocs(mostIds:success)
////                                        }
////                      x              }
//
// //   viewModel.bullshitAddCards()
//}) {
//    Image("googleLogo")
//        .resizable()
//        .frame(width: 35, height: 35)
//}
//.frame(width: 120, height: 50)
//.background(.white)
//.cornerRadius(15)
//.shadow(radius: 5)




//public func addNewStaticCards(){
//
//    let docRefs = db.collection("cards")
//
//    let id = UUID().uuidString;
//    docRefs.document(id).setData([
//        "id" : id,
//        "question": "If you want children, how many children do you want?",
//        "choices": ["1","2","3+"],
//        "categoryType": "Values",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id1 = UUID().uuidString;
//    docRefs.document(id1).setData([
//        "id" : id1,
//        "question": "Would you ever go skydiving?",
//        "choices": ["Never","Whenever","after 5 years"],
//        "categoryType": "Personality",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id2 = UUID().uuidString;
//    docRefs.document(id2).setData([
//        "id" : id2,
//        "question": "Would you Rather: Hold my hand or put your arm around my waist?",
//        "choices": ["Nope","Yes","eh sorta"],
//        "categoryType": "littleThings",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id3 = UUID().uuidString;
//    docRefs.document(id3).setData([
//        "id" : id3,
//        "question": "Kiss in public or kiss in private?",
//        "choices": ["Nope","Yes","eh sorta"],
//        "categoryType": "personality",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id4 = UUID().uuidString;
//    docRefs.document(id4).setData([
//        "id" : id4,
//        "question": "Would you Rather: Go watch a movie or go watch the sunset?",
//        "choices": ["Nope","Yes","eh sorta"],
//        "categoryType": "Values",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id5 = UUID().uuidString;
//    docRefs.document(id5).setData([
//        "id" : id5,
//        "question": "Would you Rather: Kiss on the cheek or kiss on the forehead?",
//        "choices": ["Nope","Yes","eh sorta"],
//        "categoryType": "Values",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//}
