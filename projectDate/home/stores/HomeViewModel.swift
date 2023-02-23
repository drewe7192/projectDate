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
    @Published var cardsSwipedToday: [String] = []
    @Published var cardsFromSwipedIds: [CardModel] = []
    @Published var valuesCount: [CardModel] = []
    @Published var littleThingsCount: [CardModel] = []
    @Published var commitmentCount: [CardModel] = []
    @Published var userProfile: ProfileModel = ProfileModel(id: "", fullName: "", location: "")
    @Published var profileImage: UIImage = UIImage()
    
    private var db = Firestore.firestore()
    
    let storage = Storage.storage()
    
    init(){
        getAllData(){ (success) -> Void in
            if success {
                self.readUserProfile()
                self.getStorageFile()
            }
        }
        getCardsSwipedToday(){ (success) -> Void in
            if !success.isEmpty {
                self.getCardFromIds(cardIds: success)
            }
        }
    }
    
    public func getAllData(completed: @escaping (_ success: Bool) -> Void){
       db.collection("cards").addSnapshotListener{ (querySnapshot, error) in
            guard let documents = querySnapshot?.documents
            else {
                print("No documents")
                return
            }
            
            self.cards = documents.compactMap {document -> CardModel? in
                do {
                    return try document.data(as: CardModel.self)
                } catch {
                    print("Error decoding document into Message: \(error)")
                    return nil
                }
            }
        }
       completed(true)
    }
    
    public func readUserProfile(){
             db.collection("profiles")
            .whereField("userId", isEqualTo: Auth.auth().currentUser?.uid as Any)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
//                        print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                        do{
                            if !data.isEmpty{
                                self.userProfile = try document.data(as: ProfileModel.self)
                            }
                        } catch {
                            print("Error!")
                        }
                       
                    }
                }
        }
    }
    
    public func createUserProfile(){
        
        let id = UUID().uuidString
        
        let docData: [String: Any] = [
            "id": id,
            "fullName": userProfile.fullName,
            "location": userProfile.location,
            "userId": Auth.auth().currentUser?.uid
        ]
        
        let docRef = db.collection("profiles").document(id)
        
        docRef.setData(docData) {error in
            if let error = error{
                print("Error creating new card: \(error)")
            } else {
                print("Successfully created userProfile!")
            }
        }
    }
    
    
    public func updateUserProfile(updatedProfile: ProfileModel){
        let docData: [String: Any] = [
            "fullName": updatedProfile.fullName,
            "location": updatedProfile.location
        ]

        let docRef = db.collection("profiles").document(userProfile.id)

        docRef.updateData(docData) {error in
            if let error = error{
                print("Error creating new card: \(error)")
            } else {
                print("Document successfully updated userProfile!")
            }
        }
    }
    
    // change today to this week
    public func getCardsSwipedToday(completed: @escaping (_ success: [String]) -> Void) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let start = calendar.date(from: components)!
        let end = calendar.date(byAdding: .day, value: 1, to: start)!
        
        db.collection("swipedCards")
            .whereField("userId", isEqualTo: Auth.auth().currentUser?.uid as Any)
            .whereField("swipedDate", isGreaterThan: start)
            .whereField("swipedDate", isLessThan: end)
            .addSnapshotListener {(querySnapshot, error) in
                guard let documents = querySnapshot?.documents
                else{
                    print("No documents")
                    return completed([])
                }
                self.cardsSwipedToday = documents.map { $0["cardId"]! as! String }
                completed(self.cardsSwipedToday)
            }
    }
    
    private func getCardFromIds(cardIds: [String]) {
        db.collection("cards")
        // have to pass these cardIds in instead of directly using self.cardsSwipedToday
        // causing preview in LocalHomeView() to crash
            .whereField("id", in: cardIds)
            .addSnapshotListener{(querySnapshot, error) in
                guard let documents = querySnapshot?.documents
                else{
                    print("no documents")
                    return
                }
                
                self.cardsFromSwipedIds = documents.compactMap {document -> CardModel? in
                    do {
                        return try document.data(as: CardModel.self)
                    } catch {
                        print("Error decoding document into Message: \(error)")
                        return nil
                    }
                }
            }
        
        // setting ProgressBars for Profiler on HomeScreen
        if(!self.cardsFromSwipedIds.isEmpty){
            for card in self.cardsFromSwipedIds {
                if card.categoryType == "values" {
                    self.valuesCount.append(card)
                }else if card.categoryType == "littleThings" {
                    self.littleThingsCount.append(card)
                }else if card.categoryType == "commitment" {
                    self.commitmentCount.append(card)
                }
            }
        }
       
    }
    
    public func saveSwipedCard(card: CardModel, answer: String){
        let docData: [String: Any] = [
            "cardId": card.id,
            "answer": cardChoices(choices: card.choices, answer: answer),
            "id": UUID().uuidString,
            "swipedDate": Timestamp(date: Date()),
            "userId": Auth.auth().currentUser?.uid as Any
        ]
        
        let docRef = db.collection("swipedCards").document()
        
        docRef.setData(docData) {error in
            if let error = error {
                print("Error writing document: \(error)")
            }else {
                print("Document successfully written!")
            }
        }
    }
    
    public func createNewCard(id: String, question: String, choices: [String], categoryType: String, profileType: String ,completed: @escaping (_ success: Bool) -> Void){
        let docData: [String: Any] = [
            "id" : id,
            "question": question,
            "choices": choices,
            "categoryType": categoryType,
            "profileType": profileType,
            "createdBy": Auth.auth().currentUser?.uid as Any,
            "createdDate": Timestamp(date: Date())
        ]
        
        let docRef = db.collection("cards").document()
        
        docRef.setData(docData) {error in
            if let error = error{
                print("Error creating new card: \(error)")
                completed(false)
            } else {
                print("Document successfully written!")
                completed(true)
            }
        }
        
      
    }
    
    public func removeTimeStamp(fromDate: Date) -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
    
    private func cardChoices(choices: [String], answer: String) -> String{
        let choiceIndex = choices.firstIndex(where: { $0 == answer})
        var choice = ""
        
        switch choiceIndex {
        case 0:
            choice = "A"
        case 1:
            choice = "B"
        case 2:
            choice = "C"
        default:
            break
        }
        return choice;
    }
    
    public func uploadStorageFile(image: UIImage){
        let storageRef = storage.reference().child("\(String(describing: Auth.auth().currentUser?.uid))"+"/images/image.jpg")
        
        let data = image.jpegData(compressionQuality: 0.2)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        if let data = data {
            storageRef.putData(data, metadata: metadata) { (metadata, error) in
                        if let error = error {
                                print("Error while uploading file: ", error)
                        }

                        if let metadata = metadata {
                                print("Metadata: ", metadata)
                            }
                        }
                }
        }
    
    public func getStorageFile() {
        let islandRef = storage.reference().child("\(String(describing: Auth.auth().currentUser?.uid))"+"/images/image.jpg")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
              print("Error getting file: ", error)
          } else {
            // Data for "images/island.jpg" is returned
            let image = UIImage(data: data!)
              self.profileImage = image!
        
          }
        }
    }
    }

