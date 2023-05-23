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
import FirebaseMessaging

class HomeViewModel: ObservableObject {
    @Published var createCards: [CardModel] = MockService.cardObjectSampleData.cards
    @Published var cards: [CardModel] = []
    @Published var allCards: [CardModel] = []
    @Published var cardsSwipedToday: [String] = [""]
    @Published var valuesCount: [CardModel] = []
    @Published var littleThingsCount: [CardModel] = []
    @Published var personalityCount: [CardModel] = []
    @Published var userProfile: ProfileModel = ProfileModel(id: "", fullName: "", location: "", gender: "Pick Gender", matchDay: "Pick MatchDay", messageThreadIds: [], speedDateIds: [], fcmTokens: [], preferredGender: "Pick Gender")
    @Published var profileImage: UIImage = UIImage()
    @Published var swipedRecords: [SwipedRecordModel] = []
    @Published var swipedCards: [CardModel] = []
    @Published var lastDoc: DocumentSnapshot!
    @Published var successfullMatchSnapshots: [MatchRecordModel] = []
    @Published var speedDates: [SpeedDateModel] = []
    @Published var matchRecords: [MatchRecordModel] = []
    @Published var matchProfiles: [ProfileModel] = []
    @Published var matchProfileImages: [UIImage] = []
    @Published var rolesForRoom = []
    // @Published var roomId: String = ""
    @Published var newSpeedDate: SpeedDateModel = SpeedDateModel(id: "", maleRoomCode: "", femaleRoomCode: "", roomId: "", matchProfileIds: [], eventDate: Date(), createdDate: Date(), isActive: false)
    @Published var currentSpeedDate: SpeedDateModel = SpeedDateModel(id: "", maleRoomCode: "", femaleRoomCode: "", roomId: "", matchProfileIds: [], eventDate: Date(), createdDate: Date(), isActive: false)
    @Published var swipedCardGroups: SwipedCardGroupsModel = SwipedCardGroupsModel(
        id: "" ,
        userCardGroup: SwipedCardGroupModel(
            id: "",
            profileId: "",
            cardIds: [],
            answers: [],
            gender: ""
        ),
        otherCardGroups: []
    )
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    init(){
        self.clearData()
    }
    
    //this clear the cache documents from your db
    public func clearData(){
        let settings2 = FirestoreSettings()
        settings2.isPersistenceEnabled = false
        db.settings = settings2
    }
    
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
                            self.userProfile = ProfileModel(id: data["id"] as? String ?? "", fullName: data["fullName"] as? String ?? "", location: data["location"] as? String ?? "", gender: data["gender"] as? String ?? "", matchDay: data["matchDay"] as? String ?? "", messageThreadIds: data["messageThreadIds"] as? [String] ?? [], speedDateIds: data["speedDateIds"] as? [String] ?? [], fcmTokens: data["fcmTokens"] as? [String] ?? [], preferredGender: data["preferredGender"] as? String ?? "")
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
    
    public func getSwipedRecordsThisWeek(completed: @escaping (_ swipedRecords: [SwipedRecordModel]) -> Void) {
        let matchDay = self.userProfile.matchDay == "Pick MatchDay" ? "Sunday" : self.userProfile.matchDay
        
        //PREVENTS HOMEVIEW() PREVIEW CRASH
        //let matchDay = "Monday"
        
        let matchDayString = matchDay.lowercased()
        
        let enumDayOfWeek = Date.Weekday(rawValue: matchDayString)
        
        let start = Date.today().previous(enumDayOfWeek ?? .sunday)
        let end = Date.today().next(enumDayOfWeek ?? .sunday)
        
        // if dirty clean up
        self.swipedRecords.removeAll()
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
                    completed(self.swipedRecords)
                }
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
            "messageThreadIds": [],
            "preferredGender": ""
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
        assert(updatedProfile.matchDay != "Pick MatchDay", "Need to pick a matchDay! \(updatedProfile.matchDay)")
        
        let docData: [String: Any] = [
            "fullName": updatedProfile.fullName,
            "location": updatedProfile.location,
            "gender": updatedProfile.gender,
            "userId": Auth.auth().currentUser?.uid as Any,
            "matchDay": updatedProfile.matchDay,
            "preferredGender": updatedProfile.preferredGender
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
        let matchDay = self.userProfile.matchDay == "Pick MatchDay" ? "Sunday" : self.userProfile.matchDay
        
        //PREVENTS HOMEVIEW() PREVIEW CRASH
        // let matchDay = "Monday"
        
        let matchDayString = matchDay.lowercased()
        let enumDayOfWeek = Date.Weekday(rawValue: matchDayString)
        
        let start = Date.today().previous(enumDayOfWeek ?? .sunday)
        let end = Date.today().next(enumDayOfWeek ?? .sunday)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YY"
        let startDateString = dateFormatter.string(from: start)
        let endDateString = dateFormatter.string(from: end)
        
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
                    "createdDate": Timestamp(date: Date()),
                    "gender": self.userProfile.gender
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
    
    public func getSpeedDate(speedDateIds: [String], completed: @escaping(_ speedDates: [SpeedDateModel]) -> Void){
        if !speedDateIds.isEmpty {
            let firstSpeedDate = speedDateIds.first!
            
            db.collection("speedDates")
                .whereField("id", isEqualTo: firstSpeedDate)
                .addSnapshotListener{ (querySnapshot, error) in
                    if let error {
                        print("Error getting documents from speedDates: \(error)")
                        completed([])
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            
                            if !data.isEmpty{
                                let timeStampEvent = data["eventDate"] as? Timestamp
                                let eventDate = timeStampEvent?.dateValue()
                                
                                let timeStampCreated = data["createdDate"] as? Timestamp
                                let createdDate = timeStampCreated?.dateValue()
                                
                                let speedDate = SpeedDateModel(
                                    id: data["id"] as? String ?? "",
                                    maleRoomCode: data["maleRoomCode"] as? String ?? "",
                                    femaleRoomCode: data["femaleRoomCode"] as? String ?? "",
                                    roomId: data["roomId"] as? String ?? "",
                                    matchProfileIds: data["matchProfileIds"] as? [String] ?? [],
                                    eventDate: eventDate ?? Date(),
                                    createdDate: createdDate ?? Date(),
                                    isActive: data["isActive"] as? Bool ?? false
                                )
                                
                                self.speedDates.append(speedDate)
                            }
                        }
                        completed(self.speedDates)
                    }
                }
        }
    }
    
    public func saveMatchRecords(matches: [MatchRecordModel]){
        for (match) in matches {
            let id = UUID().uuidString
            
            let docData: [String: Any] = [
                "id": id,
                "userProfileId": match.userProfileId,
                "matchProfileId": match.matchProfileId,
                "isNew": true,
                "cardIds": match.cardIds,
                "answers": match.answers,
                "createdDate": Timestamp(date: Date())
            ]
            
            let docRef = db.collection("matchRecords").document(id)
            
            docRef.setData(docData) {error in
                if let error = error{
                    print("Error creating new matchRecord: \(error)")
                } else {
                    print("Document successfully created Match record!")
                }
            }
        }
    }
    
    public func getOtherCardGroups(start: Date, end: Date, completed: @escaping(_ otherGroups: [SwipedCardGroupModel]) -> Void){
        var preferredGender = self.userProfile.gender == "Male" ? "Female" : "Male"
        
        db.collection("swipedCardGroups")
            .whereField("createdDate", isGreaterThan: start)
            .whereField("createdDate", isLessThan: end)
            .whereField("gender", isEqualTo: preferredGender)
            .limit(to: 10)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents for swipedCardGroups part 2: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        
                        if !data.isEmpty{
                            let cardGroup = SwipedCardGroupModel(id: data["id"] as? String ?? "", profileId: data["profileId"] as? String ?? "", cardIds: data["cardIds"] as? [String] ?? [""], answers: data["answers"] as? [String] ?? [""], gender: data["gender"] as? String ?? "")
                            
                            // filtering out userCardGroup becuase Invalid Query if done in .whereField() above
                            if cardGroup.profileId != self.userProfile.id {
                                self.swipedCardGroups.otherCardGroups.append(cardGroup)
                            }
                        }
                    }
                    completed(self.swipedCardGroups.otherCardGroups)
                }
            }
    }
    
    public func getUserCardGroup(start: Date, end: Date, completed: @escaping(_ userGroup: SwipedCardGroupModel) -> Void){
        db.collection("swipedCardGroups")
            .whereField("profileId", isEqualTo: self.userProfile.id)
            .whereField("createdDate", isGreaterThan: start)
            .whereField("createdDate", isLessThan: end)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents for swipedCardGroups: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if !data.isEmpty{
                            self.swipedCardGroups.userCardGroup = SwipedCardGroupModel(id: data["id"] as? String ?? "", profileId: data["profileId"] as? String ?? "", cardIds: data["cardIds"] as? [String] ?? [""], answers: data["answers"] as? [String] ?? [""], gender: data["gender"] as? String ?? "")
                            
                            completed(self.swipedCardGroups.userCardGroup)
                        }
                    }
                }
            }
    }
    
    public func getMatchRecordsForPreviousWeek(completed: @escaping(_ matchRecordsPreviousWeek: [MatchRecordModel]) -> Void) {
        
        let matchDay = self.userProfile.matchDay == "Pick MatchDay" ? "Sunday" : self.userProfile.matchDay
        
        //SWITCH TO PREVENT PREVIEW CRASHING
        //let matchDay = "Monday"
        
        let matchDayString = matchDay.lowercased()
        let enumDayOfWeek = Date.Weekday(rawValue: matchDayString)
        
        let start = Date.today().previous(enumDayOfWeek ?? .sunday).previous(enumDayOfWeek ?? .sunday)
        let end = Date.today().previous(enumDayOfWeek ?? .sunday)
        
        db.collection("matchRecords")
            .whereField("userProfileId", isEqualTo: self.userProfile.id)
            .whereField("createdDate", isGreaterThan: start)
            .whereField("createdDate", isLessThan: end)
        // .whereField("isNew", isEqualTo: true)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents from matchRecords: \(err)")
                    completed([])
                } else {
                    for document in querySnapshot!.documents {
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
    
    public func updateMatchRecords(matchRecords: [MatchRecordModel]){
        for (randomMatch) in matchRecords {
            
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
    
    public func getProfiles(matchRecords: [MatchRecordModel], completed: @escaping(_ matchProfiles: [ProfileModel]) -> Void ){
        var matchIds: [String] = []
        
        for matchRecord in matchRecords {
            matchIds.append(matchRecord.matchProfileId)
        }
        
        db.collection("profiles")
            .whereField("id", in: matchIds)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completed([])
                } else {
                    for document in querySnapshot!.documents {
                        //                        print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                        if !data.isEmpty{
                            let profile = ProfileModel(id: data["id"] as? String ?? "", fullName: data["fullName"] as? String ?? "", location: data["location"] as? String ?? "", gender: data["gender"] as? String ?? "", matchDay: data["matchDay"] as? String ?? "", messageThreadIds: data["messageThreadIds"] as? [String] ?? [], speedDateIds: data["speedDateIds"] as? [String] ?? [], fcmTokens: data["fcmTokens"] as? [String] ?? [], preferredGender: data["preferredGender"] as? String ?? "")
                            
                            self.matchProfiles.append(profile)
                        }
                    }
                    completed(self.matchProfiles)
                }
            }
    }
    
    public func getMatchStorageFiles(matchProfiles: [ProfileModel]) {
        for profile in matchProfiles {
            let imageRef = storage.reference().child("\(String(describing: profile.id))"+"/images/image.jpg")
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            imageRef.getData(maxSize: Int64(1 * 1024 * 1024)) { data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    print("Error getting file: ", error)
                } else {
                    let image = UIImage(data: data!)
                    self.matchProfileImages.append(image!)
                }
            }
        }
    }
    
    public func saveSpeedDate() {
        let id = UUID().uuidString
        
        let docData: [String: Any] = [
            "id": id,
            "roomId": self.newSpeedDate.roomId,
            "hostProfileId": userProfile.id,
            "matchProfileIds": [matchProfiles[0].id,matchProfiles[1].id,matchProfiles[2].id],
            "eventDate": Timestamp(date: self.newSpeedDate.eventDate),
            "createdDate": Timestamp(date: Date()),
            "maleRoomCode" : self.newSpeedDate.maleRoomCode,
            "femaleRoomCode" : self.newSpeedDate.femaleRoomCode
        ]
        
        let docRef = db.collection("speedDates").document(id)
        
        docRef.setData(docData) {error in
            if let error = error{
                print("Error creating new speedDate: \(error)")
            } else {
                print("Document successfully created new speedDate record!")
            }
        }
        
        //updating profiles with new speedDateId
        let updateSpeedDateIds: [String: Any] = [
            "speedDateIds": FieldValue.arrayUnion([id])
        ]
        
        let hostProfileRef = db.collection("profiles").document(userProfile.id)
        let matchProfileRef_1 = db.collection("profiles").document(matchProfiles[0].id)
        let matchProfileRef_2 = db.collection("profiles").document(matchProfiles[1].id)
        let matchProfileRef_3 = db.collection("profiles").document(matchProfiles[2].id)
        
        hostProfileRef.updateData(updateSpeedDateIds) {error in
            if let error = error{
                print("Error updating speedDateId: \(error)")
            } else {
                print("speedDateId successfully saved hostProfile!")
            }
        }
        
        matchProfileRef_1.updateData(updateSpeedDateIds) {error in
            if let error = error{
                print("Error updating speedDateId: \(error)")
            } else {
                print("speedDateId successfully saved matchProfile_1!")
            }
        }
        
        matchProfileRef_2.updateData(updateSpeedDateIds) {error in
            if let error = error{
                print("Error updating speedDateId: \(error)")
            } else {
                print("speedDateId successfully saved matchProfile_2!")
            }
        }
        
        matchProfileRef_3.updateData(updateSpeedDateIds) {error in
            if let error = error{
                print("Error updating speedDateId: \(error)")
            } else {
                print("speedDateId successfully saved matchProfile_3!")
            }
        }
        
        
    }
    
    public func saveMessageToken() {
        let token = Messaging.messaging().fcmToken
        
        let docData: [String: Any] = [
            "fcmTokens": FieldValue.arrayUnion([token!])
        ]
        
        let docRef = db.collection("profiles").document(userProfile.id)
        
        docRef.updateData(docData) {error in
            if let error = error{
                print("Error creating new card: \(error)")
            } else {
                print("Document successfully saved fcmToken!")
            }
        }
    }
    
    public func removeSpeedDate() {
        if !self.userProfile.speedDateIds.isEmpty{
            let removeSpeedDateId: [String: Any] = [
                "speedDateIds": FieldValue.arrayRemove([self.userProfile.speedDateIds.first!])
            ]
            
            db.collection("profiles").document(self.userProfile.id)
                .updateData(removeSpeedDateId) {error in
                    if let error = error{
                        print("Error removing speedDateId: \(error)")
                    } else {
                        print("speedDateId successfully removed!")
                    }
                }
            
        }
    }
    
    public func getAllRooms(completed: @escaping(_ allRooms: GetAllRoomsResponseModel) -> Void){
        guard let url = URL(string: "https://us-central1-projectdate-a365b.cloudfunctions.net/getAllRooms") else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                completed(GetAllRoomsResponseModel(data: []))
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let rooms = try JSONDecoder().decode(GetAllRoomsResponseModel.self, from: data)
                        completed(rooms)
                    } catch let error {
                        print("Error decoding: ", error)
                        completed(GetAllRoomsResponseModel(data: []))
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    public func createRoomCodes(completed: @escaping (_ newRoomCodes: RolesModel) -> Void) {
        guard let url = URL(string: "https://us-central1-projectdate-a365b.cloudfunctions.net/createRoomCodes?room_id=\(self.currentSpeedDate.roomId)") else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                completed(RolesModel(data: []))
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let newRoles = try JSONDecoder().decode(RolesModel.self, from: data)
                        completed(newRoles)
                    } catch let error {
                        completed(RolesModel(data: []))
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    public func getRoomCodes(completed: @escaping (_ roomCodes: RolesModel) -> Void) {
        guard let url = URL(string: "https://us-central1-projectdate-a365b.cloudfunctions.net/getRoomCodes?room_id=\(self.currentSpeedDate.roomId)") else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                completed(RolesModel(data: []))
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedRoles = try JSONDecoder().decode(RolesModel.self, from: data)
                        completed(decodedRoles)
                    } catch let error {
                        completed(RolesModel(data: []))
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    public func createRoom(completed: @escaping (_ roomId: String) -> Void) {
        guard let url = URL(string: "https://us-central1-projectdate-a365b.cloudfunctions.net/createRoom") else { fatalError("Missing URL") }
        
        let json: [String: Any]  = [
            "name": "room_\(UUID().uuidString)",
            "description": "This is a sample description for the room",
            "template_id": "638d9d1b2b58471af0e13f08",
            "region": "us"
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonData
        urlRequest.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                completed("")
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                        let roomId = String(data:data, encoding: .utf8)
                        self.currentSpeedDate.roomId = roomId!
                        completed(self.currentSpeedDate.roomId)
              
                }
            } else {
                completed("status Code not 200")
            }
        }
        dataTask.resume()
    }
    
    public func getActiveSessions(completed: @escaping(_ activeSessions: GetActiveSessionsResponseModel) -> Void){
        guard let url = URL(string: "https://us-central1-projectdate-a365b.cloudfunctions.net/getActiveSessions") else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                completed(GetActiveSessionsResponseModel(data: []))
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let actSessions = try JSONDecoder().decode(GetActiveSessionsResponseModel.self, from: data)
                        completed(actSessions)
                    } catch let error {
                        print("Error decoding: ", error)
                        completed(GetActiveSessionsResponseModel(data: []))
                    }
                }
            }
        }
        dataTask.resume()
    }
}

