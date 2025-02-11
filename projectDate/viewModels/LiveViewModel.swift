//
//  LocalliveViewModel.swift
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

class LiveViewModel: ObservableObject {
    @Published var cardsSwipedToday: [String] = [""]
    @Published var userProfile: ProfileModel = ProfileModel(id: "", fullName: "", location: "", gender: "Pick Gender", messageThreadIds: [], speedDateIds: [], fcmTokens: [], preferredGender: "Pick Gender",currentRoomId: "")
    @Published var profileImage: UIImage = UIImage()
    @Published var lastDoc: DocumentSnapshot!
    @Published var matchProfiles: [ProfileModel] = []
    @Published var matchProfileImages: [UIImage] = []
    @Published var rolesForRoom = []
    // @Published var roomId: String = ""
    @Published var newSpeedDate: SpeedDateModel = SpeedDateModel(id: "", maleRoomCode: "", femaleRoomCode: "", roomId: "", matchProfileIds: [], eventDate: Date(), createdDate: Date(), isActive: false)
    @Published var currentSpeedDate: SpeedDateModel = SpeedDateModel(id: "", maleRoomCode: "", femaleRoomCode: "", roomId: "", matchProfileIds: [], eventDate: Date(), createdDate: Date(), isActive: false)
    
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
                            self.userProfile = ProfileModel(id: data["id"] as? String ?? "", fullName: data["fullName"] as? String ?? "", location: data["location"] as? String ?? "", gender: data["gender"] as? String ?? "", messageThreadIds: data["messageThreadIds"] as? [String] ?? [], speedDateIds: data["speedDateIds"] as? [String] ?? [], fcmTokens: data["fcmTokens"] as? [String] ?? [], preferredGender: data["preferredGender"] as? String ?? "",currentRoomId: data["currentRoomId"] as? String ?? "")
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
        let docData: [String: Any] = [
            "fullName": updatedProfile.fullName,
            "location": updatedProfile.location,
            "gender": updatedProfile.gender,
            "userId": Auth.auth().currentUser?.uid as Any,
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
        
        let docData: [String: Any] = [
            "currentRoomId": self.currentSpeedDate.roomId,
        ]
        
        let docRef = db.collection("profiles").document(self.userProfile.id)
        
        docRef.updateData(docData) {error in
            if let error = error{
                print("Error updating userProfile: \(error)")
            } else {
                print("successfully updated userProfile!")
            }
        }
        
        
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
    
    public func getUserProfileForBackground(completed: @escaping (_ profile: ProfileModel) -> Void){
        var profile = ProfileModel(id: "", fullName: "", location: "", gender: "Pick Gender", messageThreadIds: [], speedDateIds: [], fcmTokens: [], preferredGender: "Pick Gender", currentRoomId: "")

        db.collection("profiles")
            .whereField("userId", isEqualTo: Auth.auth().currentUser?.uid as Any)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completed(ProfileModel(id: "", fullName: "", location: "", gender: "Pick Gender", messageThreadIds: [], speedDateIds: [], fcmTokens: [], preferredGender: "Pick Gender", currentRoomId: ""))
                } else {
                    for document in querySnapshot!.documents {
                        //                        print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                        if !data.isEmpty{
                            profile = ProfileModel(id: data["id"] as? String ?? "", fullName: data["fullName"] as? String ?? "", location: data["location"] as? String ?? "", gender: data["gender"] as? String ?? "", messageThreadIds: data["messageThreadIds"] as? [String] ?? [], speedDateIds: data["speedDateIds"] as? [String] ?? [], fcmTokens: data["fcmTokens"] as? [String] ?? [], preferredGender: data["preferredGender"] as? String ?? "", currentRoomId: data["currentRoomId"] as? String ?? "")
                        }
                    }
                    completed(profile)
                }
            }
    }
    
    public func checkForPeer(userProfileBackground: ProfileModel) {
        let mainTok = userProfileBackground.fcmTokens.first!
        let currRoomId = userProfileBackground.currentRoomId
        guard let url = URL(string: "https://us-central1-projectdate-a365b.cloudfunctions.net/checkForPeer?fcmToken=\(mainTok)&currentRoomId=\(currRoomId)") else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let result = String(data:data, encoding: .utf8)
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
}

