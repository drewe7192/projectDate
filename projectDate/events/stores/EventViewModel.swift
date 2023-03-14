//
//  EventViewModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/21/23.
//

import Foundation

import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage
import UIKit

class EventViewModel: ObservableObject {
    @Published var events: [EventModel] = []
    
    
    private var db = Firestore.firestore()
//
//    init(){
//        getEvents()
//    }
    
//    private func getEvents(){
//        db.collection("events").addSnapshotListener{ (querySnapshot, error) in
//             guard let documents = querySnapshot?.documents
//             else {
//                 print("No documents")
//                 return
//             }
//
//            self.events = documents.compactMap {document -> EventModel? in
//                 do {
//                     return try document.data(as: EventModel.self)
//                 } catch {
//                     print("Error decoding document into Message: \(error)")
//                     return nil
//                 }
//             }
//         }
//    }
    
    public func updateEventParticipants(event: EventModel, action: String){
        let docRef = db.collection("events").document(event.id)
        
        if(action == "remove"){
            docRef.updateData([
                "participants": FieldValue.arrayRemove([Auth.auth().currentUser!.uid])
            ])
        } else if (action == "add"){
            docRef.updateData([
                "participants": FieldValue.arrayUnion([Auth.auth().currentUser!.uid])
            ])
        }
    }
    
    init(forPreview: Bool = false) {
        if forPreview {
            events = MockService.eventsSampleData
        }
    }
}
