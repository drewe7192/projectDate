//
//  LocalHomeViewModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import Foundation

import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage
import UIKit

class HomeViewModel: ObservableObject {
    @Published var createCards: [CardModel] = MockService.cardObjectSampleData.cards
    @Published var cards: [CardModel] = []
    @Published var allCards: [CardModel] = []
    @Published var cardsSwipedToday: [String] = [""]
    //@Published var cardsNotSwiped: [CardModel] = []
    @Published var valuesCount: [CardModel] = []
    @Published var littleThingsCount: [CardModel] = []
    @Published var personalityCount: [CardModel] = []
    //@Published var userProfile: ProfileModel = ProfileModel(id: "", fullName: "", location: "")
    @Published var profileImage: UIImage = UIImage()
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    init(){
        self.clearData()
    }
    
    public func clearData(){
        //this clear the cache documents from your db
        let settings2 = FirestoreSettings()
        settings2.isPersistenceEnabled = false
        db.settings = settings2
        
    }
        
//    public func getAllData(completed: @escaping (_ success: Bool) -> Void){
//
//
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.year, .month, .day], from: Date())
//
//        //still gotta change these to a week!
//        let start = calendar.date(from: components)!
//        let end = calendar.date(byAdding: .day, value: 1, to: start)!
//
//        db.collection("swipedCards")
//            .whereField("userId", isEqualTo: Auth.auth().currentUser?.uid as Any)
//            .whereField("swipedDate", isGreaterThan: start)
//            .whereField("swipedDate", isLessThan: end)
//            .addSnapshotListener {(querySnapshot, error) in
//                guard let documents = querySnapshot?.documents
//                else{
//                    print("No documents")
//                    return
//                }
//                self.cardsSwipedToday = documents.map { $0["cardId"]! as! String }
//            }
//        completed(true)
//    }

    
    
//    public func saveSwipedCard(card: CardModel, answer: String, completed: @escaping (_ success: Bool) -> Void){
//        let docData: [String: Any] = [
//            "cardId": card.id,
//            "answer": cardChoices(choices: card.choices, answer: answer),
//            "id": UUID().uuidString,
//            "swipedDate": Timestamp(date: Date()),
//            "userId": Auth.auth().currentUser?.uid as Any
//        ]
//
//        let docRef = db.collection("swipedCards").document()
//
//        docRef.setData(docData) {error in
//            if let error = error {
//                print("Error writing document: \(error)")
//                completed(false)
//            }else {
//                print("Document successfully written!")
//                completed(true)
//            }
//        }
//    }
    
    public func createNewCard(id: String, question: String, choices: [String], categoryType: String, profileType: String , profileId: String, completed: @escaping (_ success: Bool) -> Void){
        let docData: [String: Any] = [
            "id" : id,
            "question": question,
            "choices": choices,
            "categoryType": categoryType,
            "profileType": profileType,
            "createdBy": profileId,
            "createdDate": Timestamp(date: Date())
        ]
        
        let docRef = db.collection("cards").document(id)
        
        docRef.setData(docData) {error in
            if let error = error{
                print("Error creating new card: \(error)")
                completed(false)
            } else {
                print("Card successfully created!")
                completed(true)
            }
        }
    }
    
//    private func removeTimeStamp(fromDate: Date) -> Date {
//        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
//            fatalError("Failed to strip time from Date object")
//        }
//        return date
//    }
    
//    private func cardChoices(choices: [String], answer: String) -> String{
//        let choiceIndex = choices.firstIndex(where: { $0 == answer})
//        var choice = ""
//        
//        switch choiceIndex {
//        case 0:
//            choice = "A"
//        case 1:
//            choice = "B"
//        case 2:
//            choice = "C"
//        default:
//            break
//        }
//        return choice;
//    }
    
//    public func uploadStorageFile(image: UIImage){
//        let storageRef = storage.reference().child("\(String(describing: Auth.auth().currentUser?.uid))"+"/images/image.jpg")
//        let data = image.jpegData(compressionQuality: 0.2)
//        
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpg"
//        
//        if let data = data {
//            storageRef.putData(data, metadata: metadata) { (metadata, error) in
//                if let error = error {
//                    print("Error while uploading file: ", error)
//                }
//                
//                if let metadata = metadata {
//                    print("Metadata: ", metadata)
//                }
//            }
//        }
//    }
    
    public func getStorageFile() {
        let imageRef = storage.reference().child("\(String(describing: Auth.auth().currentUser?.uid))"+"/images/image.jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("Error getting file: ", error)
            } else {
                let image = UIImage(data: data!)
                self.profileImage = image!
                
            }
        }
    }
}

