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
    @Published var userProfile: ProfileModel = ProfileModel(id: "", fullName: "", location: "", gender: "Pick Gender", matchDay: "Pick MatchDay", messageThreadIds: [])
    @Published var profileImage: UIImage = UIImage()
    @Published var swipedRecords: [SwipedRecordModel] = []
    @Published var swipedCards: [CardModel] = []
    @Published var lastDoc: DocumentSnapshot!
    @Published var successfullMatchSnapshots: [MatchRecordModel] = []
    
    @Published var increm: Int = 0
    
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
    
    public func getUserProfile(completed: @escaping (_ profileId: String) -> Void){
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
                            self.userProfile = ProfileModel(id: data["id"] as? String ?? "", fullName: data["fullName"] as? String ?? "", location: data["location"] as? String ?? "", gender: data["gender"] as? String ?? "", matchDay: data["matchDay"] as? String ?? "", messageThreadIds: data["messageThreadIds"] as? [String] ?? [])
                        }
                    }
                    completed(self.userProfile.id)
                }
            }
    }
    
    public func getStorageFile(profileId: String) {
        let imageRef = storage.reference().child("\(String(describing: profileId))"+"/images/image.jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imageRef.getData(maxSize: Int64(1 * 1024 * 1024)) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("Error getting file: ", error)
            } else {
                let image = UIImage(data: data!)
                self.profileImage = image!
                
            }
        }
    }
    
    //NEED TO UPDATE THIS TO A WEEK! BUT AFTER TESTING
    public func getSwipedRecordsThisWeek(completed: @escaping (_ swipedRecords: [SwipedRecordModel]) -> Void) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let start = calendar.date(from: components)!
        let end = calendar.date(byAdding: .day, value: 1, to: start)!
        
        // if dirty clean up
        self.swipedRecords.removeAll()
        print("count: \(self.swipedRecords.count)")
        var query: Query!
        
        //pagination: get first n cards or get the next n cards
            query = db.collection("swipedRecords")
        
            query
            .whereField("profileId", isEqualTo: self.userProfile.id)
            .whereField("swipedDate", isGreaterThan: start)
            .whereField("swipedDate", isLessThan: end)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents from swipedRecords: \(err)")
                    completed([])
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        
                        if !data.isEmpty{
                            let swipedRecord = SwipedRecordModel(id: data["id"] as? String ?? "", answer: data["answer"] as? String ?? "", cardId: data["cardId"] as? String ?? "", profileId: data["profileId"] as? String ?? "")
                            
                            self.swipedRecords.append(swipedRecord)
                        }
                    }
                    print("count after: \(self.swipedRecords.count)")
                    completed(self.swipedRecords)
                }
            }
    }
    
    // not using this func right now but we're definitely gonna need this for future features
    public func getSwipedCardsFromSwipedRecords(swipedRecords: [SwipedRecordModel]) {
        //using this func because swipedRecords could include cards user hasnt answered & possible duplicates
        var cardIds = getUniqueSwipedCardRecords(swipedRecords: swipedRecords)
        var batches: [Any] = []
        
        //sanity check: making swipedCards clean if dirty
        self.swipedCards.removeAll()
        
        // workaround for the Firebase Query "IN" Limit of 10
        while(!cardIds.isEmpty){
            //splice Array: get first 10 and remove the same 10 from array
            let batch = Array(cardIds.prefix(10))
            let count = cardIds.count
            if count < 10{
                cardIds.removeSubrange(ClosedRange(uncheckedBounds: (lower: 0, upper: count - 1)))
            } else{
                cardIds.removeSubrange(ClosedRange(uncheckedBounds: (lower: 0, upper: 9)))
            }
            
            //Batch queue to call db for every batch
            batches.append(
                db.collection("cards")
                //here's the issue: batch has a limit of 10
                // condition because your getting this data for the Profiler which shows how many cards you've swiped
                    .whereField("id", in: batch)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                let data = document.data()
                                
                                if !data.isEmpty{
                                    let swipedCards = CardModel(id: data["id"] as? String ?? "", question: data["question"] as? String ?? "", choices: data["choices"] as? [String] ?? [""], categoryType: data["categoryType"] as? String ?? "", profileType: data["profileType"] as? String ?? "")
                                    
                                    self.swipedCards.append(swipedCards)
                                }
                            }
                            //another sanity check if dirty.. not sure if we need this
                            self.swipedCards.removeAll()
                        }
                    }
            )
        }
    }
    
    public func createUserProfile(completed: @escaping(_ createdUserProfileId: String) -> Void){
        
        let id = UUID().uuidString
        let docData: [String: Any] = [
            "id": id,
            "fullName": Auth.auth().currentUser?.displayName as Any,
            "location": "",
            "gender": "",
            "userId": Auth.auth().currentUser?.uid as Any,
            "matchDay": "",
            "messageThreadIds": []
        ]
        
        let docRef = db.collection("profiles").document(id)
        
        docRef.setData(docData) {error in
            if let error = error{
                print("Error creating new userProfile: \(error)")
                completed("")
            } else {
                print("Successfully created userProfile!")
                self.userProfile.id = id
                self.userProfile.fullName = Auth.auth().currentUser?.displayName ?? ""
                completed(self.userProfile.id)
            }
        }
    }
    
    public func updateUserProfile(updatedProfile: ProfileModel, completed: @escaping(_ profileId: String) -> Void){
        let docData: [String: Any] = [
            "fullName": updatedProfile.fullName,
            "location": updatedProfile.location,
            "gender": updatedProfile.gender,
            "userId": Auth.auth().currentUser?.uid as Any,
            "matchDay": updatedProfile.matchDay
        ]
        
        let docRef = db.collection("profiles").document(updatedProfile.id)
        
        docRef.updateData(docData) {error in
            if let error = error{
                print("Error updating userProfile: \(error)")
                completed("")
            } else {
                print("successfully updated userProfile!")
                completed(updatedProfile.id)
            }
        }
    }
    
    private func getUniqueSwipedCardRecords(swipedRecords: [SwipedRecordModel]) -> [String] {
        var cardIds: [String] = []
        let answeredRecords = swipedRecords.filter{$0.answer != ""}
        //you shouldnt get the same answered card twice but just in case make it unique
        let uniqueRecords = answeredRecords.unique{$0.cardId}
        
        for card in uniqueRecords {
            cardIds.append(card.cardId)
        }
        return cardIds
    }
    
    public func saveSwipedCardGroup(swipedRecords: [SwipedRecordModel]){
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let start = calendar.date(from: components)!
        let end = calendar.date(byAdding: .day, value: 1, to: start)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YY"
        let startDateString = dateFormatter.string(from: start)
        let endDateString = dateFormatter.string(from: end)
      //  let fallsBetween = (start...end).contains(Date())
        
        var cardIds: [String] = []
        var answers: [String] = []
        let id = UUID().uuidString
        
        let answeredRecords = swipedRecords.filter{$0.answer != ""}
        let uniqueRecords = answeredRecords.unique{$0.cardId}
        
        for card in uniqueRecords {
            cardIds.append(card.cardId)
            answers.append(card.answer)
        }
        
        let docRef = db.collection("swipedCardGroups").document("Week: \(startDateString)-\(endDateString)")
        
        docRef.getDocument{ (document, error) in
            if ((document?.exists) != nil) {
                let docData2: [String: Any] = [
                    "id": id,
                    "profileId": self.userProfile.id,
                    "cardIds": cardIds,
                    "answers": answers,
                    "createdDate": Timestamp(date: Date())
                ]
                
                docRef.setData(docData2) {error in
                    if let error = error{
                        print("Error creating new cardGroup: \(error)")
                    } else {
                        print("Document successfully created swipedCardGroups!")
                    }
            }
            } else {
                let docData: [String: Any] = [
                    "cardIds": cardIds,
                    "answers": answers
                ]
                docRef.updateData(docData) {error in
                    if let error = error{
                        print("Error updating cardGroup: \(error)")
                    } else {
                        print("Document successfully updated swipedCardGroups!")
                    }
                }
            }
        }
    }
    
    public func updateCount() {
        self.increm += 1
       
    }

}

