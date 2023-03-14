//
//  HomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/18/23.
//

import SwiftUI

import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage
import UIKit

struct HomeView: View {
    @ObservedObject private var viewModel = HomeViewModel()
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var showFriendDisplay = false
    @State private var progress: Double = 0.0
    @State private var valuesCount = 0.0
    @State private var littleThingsCount = 0.0
    @State private var personalityCount = 0.0
    @State private var showCardCreatedAlert: Bool = false
    @State private var profileText = ""
    @State private var updateData: Bool = false
    @State private var cards: [CardModel] = []
    @State private var lastDoc: Any = []
    @State private var swipedRecords: [SwipedRecordModel] = []
    @State private var swipedCards: [CardModel] = []
    @State private var swipedcardsForProgressCircle: [CardModel] = []
    @State private var userProfile: ProfileModel = ProfileModel(id: "", fullName: "", location: "", gender: "Pick gender")
    @State private var matchRecords: [MatchRecordModel] = []
    @State private var swipedCardGroups: SwipedCardGroupsModel = SwipedCardGroupsModel(
        id: "" ,
        userCardGroup: SwipedCardGroupModel(
            id: "",
            profileId: "",
            cardIds: [],
            answers: []),
            otherCardGroups: []
    )
    
    @State private var profileImage: UIImage? = UIImage()
    @State private var userMatchSnapshots: [CardGroupSnapShotModel] = []
    @State private var potentialMatchSnapshots: [CardGroupSnapShotModel] = []
    @State private var successfullMatchSnapshots: [CardGroupSnapShotModel] = []
    @State private var showingInstructionsPopover: Bool = false
    @State private var showingBasicInfoPopover: Bool = false
    
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView{
            GeometryReader{geoReader in
                ZStack{
                    Color.mainBlack
                        .ignoresSafeArea()
                    
                    VStack{
                        headerSection(for: geoReader)
                        Divider()
                            .frame(height: geoReader.size.height * 0.001)
                            .overlay(Color.iceBreakrrrPink)
                        
                        Text("\(displayText())")
                            .bold()
                            .foregroundColor(.white)
                            .font(.custom("Superclarendon", size: geoReader.size.height * 0.03))
                            .padding(.trailing,geoReader.size.width * 0.44)
                        
                        profilerSection(for: geoReader)
                        
                        Text("How would your perfect match answer?")
                            .bold()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .font(.custom("Superclarendon", size: geoReader.size.height * 0.03))
                            .padding(geoReader.size.width * -0.03)
                        
                        cardsSection(for: geoReader)
                        
                    }
                }.position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY )
                    .alert(isPresented: $showCardCreatedAlert){
                        Alert(
                            title: Text("New Card Created!"),
                            message: Text("You'll get a notification if someone matches your perfered answer!")
                        )
                    }
                    .onAppear {
                        getUserProfile(){(profileId) -> Void in
                            if profileId != "" {
                                getStorageFile()
                                // getting these records to update the Profiler
                                getSwipedRecordsThisWeek() {(swipedRecords) -> Void in
                                    if !swipedRecords.isEmpty {
                                        getCardFromRecords(swipedRecords: swipedRecords)
                                    }
                                }
                            } else {
                                createUserProfile() {(createdUserProfileId) -> Void in
                                    if createdUserProfileId != "" {
                                        showingBasicInfoPopover.toggle()
                            
                                    }
                                    
                                }
                                
                            }
                        }
                        
                        let weekday = Calendar.current.component(.weekday, from: Date())
                        
                        //change this has to 6 for friday
                        if(weekday == 6) {
                            // If theres no matchRecords for this week run match logic and find matches
                            // Runs once a week
                            getMatchRecordsForThisWeek() {(matchRecords) -> Void in
                                if matchRecords.isEmpty {
                                    getCardGroups() {(cardGroups) -> Void in
                                        if !cardGroups.userCardGroup.id.isEmpty {
                                            print("we made it here")
//                                            findMatches(cardGroups: cardGroups) {(successFullMatches) -> Void in
//                                                if !successFullMatches.isEmpty {
//                                                    saveMatchRecords(matches: successFullMatches)
//                                                    viewRouter.currentPage = .matchPage
//                                                }
//                                            }


                                        }

                                    }
                                }
                            }
                        }

                    }
                    .onChange(of: updateData) { _ in
                        getSwipedRecordsThisWeek() {(swipedRecords) -> Void in
                            if !swipedRecords.isEmpty {
                                saveSwipedCardGroup(swipedRecords: swipedRecords)
                                getCardFromRecords(swipedRecords: swipedRecords)
                            }
                        }
                    }
                    .popover(isPresented: $showingBasicInfoPopover) {
                        BasicInfoPopoverView(userProfile: $userProfile, showingBasicInfoPopover: $showingBasicInfoPopover, showingInstructionsPopover: $showingInstructionsPopover)
                           }
            }
        }
    }
    
    private func headerSection(for geoReader: GeometryProxy) -> some View {
        ZStack{
            Image("logo")
                .resizable()
                .frame(width: 150,height: 50)
            
            NavigationLink(destination: SettingsView()) {
                if(self.profileImage != nil){
                    Image(uiImage: self.profileImage!)
                        .resizable()
                        .cornerRadius(20)
                        .frame(width: 50, height: 50)
                        .background(Color.black.opacity(0.2))
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .padding(.leading, geoReader.size.width * 0.8)
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .cornerRadius(20)
                        .frame(width: 50, height: 50)
                        .background(Color.black.opacity(0.2))
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .padding(.leading, geoReader.size.width * 0.8)
                }
              
            }
            
            // Dating/Friend Toggle button
            // adding this back in future versions
            
            //            Toggle(isOn: $showFriendDisplay, label: {
            //
            //            })
            //            .padding(geoReader.size.width * 0.02)
            //            .toggleStyle(SwitchToggleStyle(tint: .white))
        }
    }
    
    private func profilerSection(for geoReader: GeometryProxy) -> some View {
        HStack {
            ZStack{
                CircularProgressView(progress: setProgress())
                    .frame(width: geoReader.size.width * 0.4, height: geoReader.size.height * 0.2)
                
                Text("\(progress * 100, specifier: "%.0f")%")
                    .font(.custom("Superclarendon", size: 45))
                    .foregroundColor(.white)
            }
            
            Spacer()
                .frame(width: geoReader.size.width * 0.1)
            
            VStack(alignment: .leading){
                VStack{
                    ProgressView("Values: " + "\(self.valuesCount)%", value: self.valuesCount, total: 100)
                        .foregroundColor(.white)
                        .tint(Color.iceBreakrrrPink)
                        .frame(width: geoReader.size.width * 0.4)
                }
                
                VStack{
                    ProgressView("Little Things: " + "\(littleThingsCount)%", value: littleThingsCount, total: 100)
                        .foregroundColor(.white)
                        .tint(Color.iceBreakrrrPink)
                        .frame(width: geoReader.size.width * 0.4)
                }
                
                VStack{
                    ProgressView("Personality: " + "\(personalityCount)%", value: personalityCount, total: 100)
                        .foregroundColor(.white)
                        .tint(Color.iceBreakrrrPink)
                        .frame(width: geoReader.size.width * 0.4)
                }
            }
        }
    }
    
    private func cardsSection(for geoReader: GeometryProxy) -> some View {
        ZStack{
            CardsView(updateData: $updateData, userProfile: self.userProfile)
            VStack{
                NavigationLink(destination: CreateCardsView(showCardCreatedAlert: $showCardCreatedAlert, userProfile: self.userProfile)) {
                    ZStack{
                        Circle()
                            .foregroundColor(Color.iceBreakrrrPink)
                            .frame(width: geoReader.size.width * 0.2, height: geoReader.size.width * 0.2)
                            .shadow(radius: 10)
                        
                        Image(systemName:"plus")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                    }
                }
            }
            .position(x: geoReader.size.height * 0.07, y: geoReader.size.width * 0.85)
        }
    }
    
    public func getSwipedRecordsThisWeek(completed: @escaping (_ swipedRecords: [SwipedRecordModel]) -> Void) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let start = calendar.date(from: components)!
        let end = calendar.date(byAdding: .day, value: 1, to: start)!

        db.collection("swipedRecords")
            .whereField("profileId", isEqualTo: userProfile.id)
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
    
    private func getCardFromRecords(swipedRecords: [SwipedRecordModel]) {
        var cardIds = getUniqueRecords(swipedRecords: swipedRecords)
        var batches: [Any] = []
        
        clearStates()
        
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
                                    self.swipedcardsForProgressCircle.append(swipedCards)
                                }
                            }
                            updateProfilerBars(cardsSwiped: self.swipedCards)
                            self.swipedCards.removeAll()
                        }
                    }
            )
        }
    }
    
    private func getUniqueRecords(swipedRecords: [SwipedRecordModel]) -> [String] {
        var cardIds: [String] = []
        let answeredRecords = swipedRecords.filter{$0.answer != ""}
        //you shouldnt get the same answered card twice but just in case make it unique
        let uniqueRecords = answeredRecords.unique{$0.cardId}
        
        for card in uniqueRecords {
            cardIds.append(card.cardId)
        }
        return cardIds
    }
    
    private func clearStates(){
        self.swipedCards.removeAll()
        self.swipedcardsForProgressCircle.removeAll()
        self.valuesCount = 0
        self.littleThingsCount = 0
        self.personalityCount = 0
    }
    
    private func updateProfilerBars(cardsSwiped: [CardModel]){
        if(!cardsSwiped.isEmpty){
            for card in cardsSwiped {
                if card.categoryType == "values" {
                    self.valuesCount += 1
                }else if card.categoryType == "littleThings" {
                    self.littleThingsCount += 1
                }else if card.categoryType == "personality" {
                    self.personalityCount += 1
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
                self.profileImage = image!
                
            }
        }
    }
    
    private func saveSwipedCardGroup(swipedRecords: [SwipedRecordModel]){
        var cardIds: [String] = []
        var answers: [String] = []
        let id = UUID().uuidString
        
        let answeredRecords = swipedRecords.filter{$0.answer != ""}
        let uniqueRecords = answeredRecords.unique{$0.cardId}
        
        for card in uniqueRecords {
            cardIds.append(card.cardId)
            answers.append(card.answer)
        }
        
        let docData: [String: Any] = [
            "id": id,
            "profileId": self.userProfile.id,
            "cardIds": cardIds,
            "answers": answers,
            "createdDate": Timestamp(date: Date())
        ]
        
        let docRef = db.collection("swipedCardGroups").document(id)
        
        docRef.setData(docData) {error in
            if let error = error{
                print("Error creating new card: \(error)")
            } else {
                print("Document successfully updated swipedCardGroups!")
            }
        }
    }
    
    private func displayText() -> String{
        showFriendDisplay ? (profileText = "Friend Profile") : (profileText = "Dating Profile")
        return profileText;
    }
    
    private func setProgress() -> Double{
        // 1.0 fully fills up the circle
        self.progress = Double(self.swipedcardsForProgressCircle.count) * 0.05
        
        return Double(self.swipedcardsForProgressCircle.count) * 0.05
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
                                self.userProfile = ProfileModel(id: data["id"] as? String ?? "", fullName: data["fullName"] as? String ?? "", location: data["location"] as? String ?? "", gender: data["gender"] as? String ?? "")
                            }
                    }
                    completed(self.userProfile.id)
                }
            }
    }
    
    
    private func getMatchRecordsForThisWeek(completed: @escaping(_ matches: [MatchRecordModel]) -> Void) {
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let start = calendar.date(from: components)!
        let end = calendar.date(byAdding: .day, value: 1, to: start)!
        
        
        db.collection("matchRecords")
            .whereField("profileId", isEqualTo: userProfile.id)
            .whereField("createdDate", isGreaterThan: start)
            .whereField("createdDate", isLessThan: end)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents from matchRecords: \(err)")
                    completed([])
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()

                        if !data.isEmpty{
                            let matchRecord = MatchRecordModel(id: data["id"] as? String ?? "", userProfileId: data["userProfileId"] as? String ?? "", matchProfileId: data["matchProfileId"] as? String ?? "")
                            self.matchRecords.append(matchRecord)
                        }
                    }
                    completed(self.matchRecords)
                }
            }
    }
    
    private func getCardGroups(completed: @escaping(_ userCardGroup: SwipedCardGroupsModel) -> Void){
        // get your cardGroup for this week as well as 20 other random cardGroups
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let start = calendar.date(from: components)!
        let end = calendar.date(byAdding: .day, value: 1, to: start)!
         var swipedCardFoo: SwipedCardGroupsModel = SwipedCardGroupsModel(
            id: "" ,
            userCardGroup: SwipedCardGroupModel(
                id: "",
                profileId: "",
                cardIds: [],
                answers: []),
                otherCardGroups: []
        )
        
        
        
        db.collection("swipedCardGroups")
            .whereField("profileId", isEqualTo: userProfile.id)
            .whereField("createdDate", isGreaterThan: start)
            .whereField("createdDate", isLessThan: end)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents for swipedCardGroups: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()

                        if !data.isEmpty{
                            self.swipedCardGroups.userCardGroup = SwipedCardGroupModel(id: data["id"] as? String ?? "", profileId: data["profileId"] as? String ?? "", cardIds: data["cardIds"] as? [String] ?? [""], answers: data["answers"] as? [String] ?? [""])
                            swipedCardFoo.userCardGroup = SwipedCardGroupModel(id: data["id"] as? String ?? "", profileId: data["profileId"] as? String ?? "", cardIds: data["cardIds"] as? [String] ?? [""], answers: data["answers"] as? [String] ?? [""])
                        }
                    }
                }
            }
        
        db.collection("swipedCardGroups")
            .whereField("createdDate", isGreaterThan: start)
            .whereField("createdDate", isLessThan: end)
            .limit(to: 20)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents for swipedCardGroups part 2: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()

                        if !data.isEmpty{
                            let cardGroup = SwipedCardGroupModel(id: data["id"] as? String ?? "", profileId: data["profileId"] as? String ?? "", cardIds: data["cardIds"] as? [String] ?? [""], answers: data["answers"] as? [String] ?? [""])
                            self.swipedCardGroups.otherCardGroups.append(cardGroup)
                            swipedCardFoo.otherCardGroups.append(cardGroup)
                        }
                    }

                    completed(swipedCardFoo)
                }
            }
    }
    
    private func findMatches(cardGroups: SwipedCardGroupsModel, completed: @escaping(_ successFullMatches: [CardGroupSnapShotModel]) -> Void){
        var user = cardGroups.userCardGroup
        var others = cardGroups.otherCardGroups
       
        for (index,record) in user.cardIds.enumerated() {
            var userSnapshot = CardGroupSnapShotModel(id: UUID().uuidString, profileId: user.profileId, cardId: record, answer: user.answers[index])
            
            self.userMatchSnapshots.append(userSnapshot)
        }
        
        for(_, item) in others.enumerated() {
            for(index, item2) in item.cardIds.enumerated() {
                var othersSnapshot = CardGroupSnapShotModel(id: UUID().uuidString, profileId: user.profileId, cardId: item2, answer: user.answers[index])

                self.potentialMatchSnapshots.append(othersSnapshot)
            }
        }
        
        
        for (index, record) in self.userMatchSnapshots.enumerated() {
            for(index2, record2) in self.potentialMatchSnapshots.enumerated() {
                if(record.cardId == record2.cardId && record.answer == record2.answer) {
                    self.successfullMatchSnapshots.append(record2)
                }
            }
        }
        completed(self.successfullMatchSnapshots)
        
    }
    
    private func saveMatchRecords(matches: [CardGroupSnapShotModel]){
        let randomMatch = matches.randomElement()
        
      
            let id = UUID().uuidString
            
        if((randomMatch) == nil){
            print("you do not have any matches")
        } else {
            let docData: [String: Any] = [
                "id": id,
                "userProfileId": self.userProfile.id,
                "matchProfileId": randomMatch!.profileId,
                "createdDate": Timestamp(date: Date())
            ]
            
            let docRef = db.collection("matchRecords").document(id)
            
            docRef.setData(docData) {error in
                if let error = error{
                    print("Error creating new card: \(error)")
                } else {
                    print("Document successfully created Match record!")
                }
            }
        }
    }
    
    private func createUserProfile(completed: @escaping(_ createdUserProfileId: String) -> Void){
        
        let id = UUID().uuidString
        let docData: [String: Any] = [
            "id": id,
            "fullName": Auth.auth().currentUser?.displayName,
            "location": "",
            "gender": "",
            "userId": Auth.auth().currentUser?.uid as Any
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
            "userId": Auth.auth().currentUser?.uid as Any
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
} 

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
