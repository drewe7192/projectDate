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
    @State private var userProfile: ProfileModel = ProfileModel(id: "", fullName: "", location: "", gender: "Pick gender", matchDay: "iceDay")
    @State private var matchRecords: [MatchRecordModel] = []
    @State private var profileImage: UIImage? = UIImage()
    @State private var userMatchSnapshots: [CardGroupSnapShotModel] = []
    @State private var potentialMatchSnapshots: [CardGroupSnapShotModel] = []
    @State private var successfullMatchSnapshots: [CardGroupSnapShotModel] = []
    @State private var showingInstructionsPopover: Bool = false
    @State private var showingBasicInfoPopover: Bool = false
    @State private var showMatchFeed: Bool = true
    @State private var showMenu: Bool = false
    @State private var swipedCardGroups: SwipedCardGroupsModel = SwipedCardGroupsModel(
        id: "" ,
        userCardGroup: SwipedCardGroupModel(
            id: "",
            profileId: "",
            cardIds: [],
            answers: []),
        otherCardGroups: []
    )
    
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
                            .padding(.bottom)
                        VStack{
                    
                            cardsSection(for: geoReader)
                            
                            HStack{
                                Text("Match Activity:")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .font(.custom("Superclarendon", size: geoReader.size.height * 0.025))
                                    .padding(.trailing,10)
                                    .padding(.bottom,3)
                                
                                HStack{
                                    Image(systemName: "flame.circle.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.white)
                              
                                    Text("Tuesdays")
                                        .foregroundColor(.iceBreakrrrBlue)
                                        .bold()
                                        .font(.system(size: 20))
                                }
                            }
                         
                            
                            ZStack{
                                if(showMatchFeed){
                                    ScrollViewReader{ (proxy: ScrollViewProxy) in
                                        ScrollView{
                                            VStack{
                                                ForEach(0..<9) { card in
                                                    ZStack{
                                                        Text("")
                                                            .frame(width: geoReader.size.width * 0.9, height: geoReader.size.height * 0.09)
                                                            .background(Color.mainGrey)
                                                            .cornerRadius(20)
                                                        
                                                        HStack{
                                                            Image("logo")
                                                                .resizable()
                                                                .cornerRadius(50)
                                                                .frame(width: 40, height: 40)
                                                                .background(Color.black.opacity(0.2))
                                                                .aspectRatio(contentMode: .fill)
                                                                .clipShape(Circle())
                                                            
                                                            
                                                            Text("Bob jones matched your answer: take a long walk and ride a bike or some shit")
                                                                .foregroundColor(.white)
                                                                .padding(.trailing)
                                                                .padding(.leading)
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                            }
                                            //                                        .onReceive(timer) { _ in
                                            //                                            withAnimation {
                                            //                                                if counter <
                                            //                                            }
                                            //                                        }
                                            
                                        }
                                        .frame(width: 0,height: 115)
                                        .padding(.top,2)
                                        .padding(.bottom,5)
                                    }
                                    
                                }else{
                                    Text("No Matches Yet")
                                        .bold()
                                        .foregroundColor(.gray.opacity(0.3))
                                        .font(.system(size: 40))
                                        .padding(.bottom, 40)
                                }
                            }
                        }
                     
                    }
                    .offset(x: self.showMenu ? geoReader.size.width/2 : 0)
                    .disabled(self.showMenu ? true : false)
                    
                    if self.showMenu {
                        MenuView()
                            .frame(width: geoReader.size.width/2)
                            .padding(.trailing,200)
                    }
                }
                .position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY )
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
        HStack{
            ZStack{
                Text("")
                    .frame(width: 40, height: 40)
                    .background(Color.black.opacity(0.2))
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Rectangle())
                    .cornerRadius(10)
                  //  .padding(.leading, geoReader.size.width * -0.45)
               
                
                Image(systemName: "line.3.horizontal.decrease")
                    .resizable()
                    .frame(width: 20, height: 10)
                    .foregroundColor(.white)
                    .aspectRatio(contentMode: .fill)
                  //  .padding(.leading, geoReader.size.width * -0.425)
            }
            .padding(.trailing,70)
            
            Text("iceBreakrrr")
                .font(.custom("Georgia-BoldItalic", size: 23))
                .bold()
                .foregroundColor(Color.iceBreakrrrBlue)
                // .padding(.leading, geoReader.size.width * 0.00)
                //.position(x: geoReader.frame(in: .local).midX, y:geoReader.size.height * 0.02)
            
            ZStack{
                Text("")
                    .cornerRadius(20)
                    .frame(width: 40, height: 40)
                    .background(Color.black.opacity(0.2))
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                   // .padding(.leading, geoReader.size.width * 0.55)
                
                Image(systemName: "bell")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .aspectRatio(contentMode: .fill)
                    //.padding(.leading, geoReader.size.width * 0.55)
                
            }
            .padding(.leading,30)
            
            NavigationLink(destination: SettingsView()) {
                //change this back
                if(self.profileImage != nil){
                    ZStack{
                        Text("")
                            .cornerRadius(20)
                            .frame(width: 40, height: 40)
                            .background(.black.opacity(0.2))
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                           // .padding(.leading, geoReader.size.width * 0.8)
                        
                        Image(uiImage: self.profileImage!)
                            .resizable()
                            .cornerRadius(20)
                            .frame(width: 30, height: 30)
                            .background(.black.opacity(0.2))
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                          //  .padding(.leading, geoReader.size.width * 0.8)
                    }
                   
                    
                } else {
                    ZStack{
                        Text("")
                            .cornerRadius(20)
                            .frame(width: 40, height: 40)
                            .background(.black.opacity(0.2))
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                          //  .padding(.leading, geoReader.size.width * 0.8)
                        
                        Image(systemName: "person.circle")
                            .resizable()
                            .cornerRadius(20)
                            .frame(width: 20, height: 20)
                            .background(Color.black.opacity(0.2))
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                          //  .padding(.leading, geoReader.size.width * 0.8)
                        
                    }
              
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
            plusButton()
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
                            self.userProfile = ProfileModel(id: data["id"] as? String ?? "", fullName: data["fullName"] as? String ?? "", location: data["location"] as? String ?? "", gender: data["gender"] as? String ?? "", matchDay: data["matchDay"] as? String ?? "")
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
        let user = cardGroups.userCardGroup
        let others = cardGroups.otherCardGroups
        
        for (index,record) in user.cardIds.enumerated() {
            let userSnapshot = CardGroupSnapShotModel(id: UUID().uuidString, profileId: user.profileId, cardId: record, answer: user.answers[index])
            
            self.userMatchSnapshots.append(userSnapshot)
        }
        
        for(_, item) in others.enumerated() {
            for(index, item2) in item.cardIds.enumerated() {
                let othersSnapshot = CardGroupSnapShotModel(id: UUID().uuidString, profileId: user.profileId, cardId: item2, answer: user.answers[index])
                
                self.potentialMatchSnapshots.append(othersSnapshot)
            }
        }
        
        for (_, record) in self.userMatchSnapshots.enumerated() {
            for(_, record2) in self.potentialMatchSnapshots.enumerated() {
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
            "fullName": Auth.auth().currentUser?.displayName as Any,
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
    
    private func plusButton() -> some View{
        GeometryReader{ geo in
            VStack{
                NavigationLink(destination: CreateCardsView(showCardCreatedAlert: $showCardCreatedAlert, userProfile: self.userProfile)) {
                    ZStack{
                        Circle()
                            .foregroundColor(Color.mainBlack)
                            .frame(width: geo.size.width * 0.2, height: geo.size.width * 0.2)
                            .shadow(radius: 10)
                        
                        Image(systemName:"plus")
                            .resizable()
                            .foregroundColor(Color.iceBreakrrrBlue)
                            .frame(width: 50, height: 50)
                    }
                }
            }
            .position(x: geo.size.height * 0.09, y: geo.size.width * 1.1)
        }
    }
} 

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
