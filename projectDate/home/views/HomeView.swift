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
    @StateObject public var viewModel = HomeViewModel()
    @ObservedObject private var messageViewModel = MessageViewModel()
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var showFriendDisplay = false
    @State private var progress: Double = 0.0
    @State private var valuesCount = 0.0
    @State private var littleThingsCount = 0.0
    @State private var personalityCount = 0.0
    @State private var showCardCreatedAlert: Bool = false
    @State private var profileText = ""
    
    @State private var updateData: Bool = false
    @State private var gotSwipedRecords: Bool = false
    
    @State private var cards: [CardModel] = []
    
    @State private var matchRecords: [MatchRecordModel] = []
    @State private var userMatchSnapshots: [CardGroupSnapShotModel] = []
    @State private var potentialMatchSnapshots: [CardGroupSnapShotModel] = []
    
    @State private var showingInstructionsPopover: Bool = false
    @State private var showingBasicInfoPopover: Bool = false
    @State private var showHamburgerMenu: Bool = false
    @State private var isStartSpeedDateNow: Bool = false
    @State private var isStartVideoNow: Bool = false
    @State private var isTimeEnded: Bool = false
    @State private var placeInLine: Int = 0
    @State private var timeLeft: Int = 0
    @State private var isPeerButtonDisabled: Bool = false
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
                        cardsAndSpeeDateSection(for: geoReader)
                            .padding(.top,10)
   //keep for now
//                        Button(action: {
//                            addspeedDate()
//                        }) {
//                            Image("googleLogo")
//                                .resizable()
//                                .frame(width: 35, height: 35)
//                        }
//                        .frame(width: 120, height: 50)
//                        .background(.white)
//                        .cornerRadius(15)
//                        .shadow(radius: 5)
                    }
                    .offset(x: self.showHamburgerMenu ? geoReader.size.width/2 : 0)
                    .disabled(self.showHamburgerMenu ? true : false)
                    
                    //Display hamburgerMenu
                    if self.showHamburgerMenu {
                        MenuView()
                            .frame(width: geoReader.size.width/2)
                            .padding(.trailing,geoReader.size.width * 0.5)
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
                  getAllData()
                }
                .onChange(of: updateData) { _ in
                    saveCards()
                }
                .popover(isPresented: $showingBasicInfoPopover) {
                    BasicInfoPopoverView(userProfile: $viewModel.userProfile,profileImage: $viewModel.profileImage,showingBasicInfoPopover: $showingBasicInfoPopover, showingInstructionsPopover: $showingInstructionsPopover)
                }
                .navigationBarItems(leading: (
                    headerSection(for: geoReader)
                        .padding(.leading, geoReader.size.width * 0.25)
                ))
            }
        }
    }
    
    private func getAllData() {
        getProfileAndRecords() {(getProfileId) -> Void in
            if getProfileId != "" {
                getMatchData()
                viewModel.getSpeedDate(speedDateIds: viewModel.userProfile.speedDateIds) {(speedDates) -> Void in
                    if !speedDates.isEmpty {
                        setPlaceInLine(){(placeIn) -> Void in
                            if placeIn != 0 {
                                timeLeft(inLine: placeIn)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func saveCards(){
        //make a cardGroup out of all the cards user swiped this week
        viewModel.getSwipedRecordsThisWeek() {(swipedRecords) -> Void in
            if !swipedRecords.isEmpty {
                viewModel.saveSwipedCardGroup(swipedRecords: swipedRecords)
                //not using this func right now but will in the future
                viewModel.getSwipedCardsFromSwipedRecords(swipedRecords: swipedRecords)
            }
        }
    }
    
    private func getMatchData(){
        let f = DateFormatter()
        //The -1 is added at the end because Calendar.current.component(.weekday, from: Date()) returns values from 1-7 but weekdaySymbols expects array indices
        let weekday = f.weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1]
        
        if(weekday == viewModel.userProfile.matchDay && viewModel.successfullMatchSnapshots.isEmpty) {
            getMatchRecordsForThisWeek() {(alreadySeenMatchRecords) -> Void in
                // If theres no matchRecords for this week run match logic and find matches
    
                if alreadySeenMatchRecords.isEmpty {
                    getCardGroups() {(userCardGroup) -> Void in
                        if !userCardGroup.userCardGroup.id.isEmpty {
                            findMatches(cardGroups: userCardGroup) {(successFullMatches) -> Void in
                                if !successFullMatches.isEmpty {
                                    saveMatchRecords(matches: successFullMatches)
                                    viewRouter.currentPage = .matchPage
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func getProfileAndRecords(completed: @escaping (_ getProfileId: String) -> Void) {
        //inital check to make sure we're not always getting data if we already have data
        if viewModel.userProfile.id == "" {
            viewModel.getUserProfile(){(profileId) -> Void in
                if profileId != "" {
                    //get profileImage
                    viewModel.getStorageFile(profileId: profileId)
                    // getting these records to display new cards user hasn't seen yet
                    viewModel.getSwipedRecordsThisWeek() {(swipedRecords) -> Void in
                        gotSwipedRecords.toggle()
                        if !swipedRecords.isEmpty {
                            viewModel.getSwipedCardsFromSwipedRecords(swipedRecords: swipedRecords)
                        }
                        completed(profileId)
                    }
                } else {
                    viewModel.createUserProfile() {(createdUserProfileId) -> Void in
                        if createdUserProfileId != "" {
                            gotSwipedRecords.toggle()
                            showingBasicInfoPopover.toggle()
                        }
                        completed(createdUserProfileId)
                    }
                }
            }
        }
    }
    
    private func headerSection(for geoReader: GeometryProxy) -> some View {
        ZStack{
            HStack{
                Text("iceBreakrrr")
                    .font(.custom("Georgia-BoldItalic", size: geoReader.size.height * 0.03))
                    .bold()
                    .foregroundColor(Color.iceBreakrrrBlue)
                    .position(x: geoReader.size.width * 0.3, y: geoReader.size.height * 0.03)
                
                Image("logo")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .background(Color.mainBlack)
                    .position(x: geoReader.size.width * -0.35, y: geoReader.size.height * 0.03)
            }
            
            HStack{
                Button(action: {
                    withAnimation{
                        self.showHamburgerMenu.toggle()
                    }
                }) {
                    ZStack{
                        Text("")
                            .frame(width: 40, height: 40)
                            .background(Color.black.opacity(0.2))
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Rectangle())
                            .cornerRadius(10)
                        
                        Image(systemName: "line.3.horizontal.decrease")
                            .resizable()
                            .frame(width: 20, height: 10)
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fill)
                    }
                }
                .position(x: geoReader.size.height * -0.08, y: geoReader.size.height * 0.03)
                
                Spacer()
                    .frame(width: geoReader.size.width * 0.55)
                
                NavigationLink(destination: NotificationsView(), label: {
                    ZStack{
                        Text("")
                            .cornerRadius(20)
                            .frame(width: 40, height: 40)
                            .background(Color.black.opacity(0.2))
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                        
                        Image(systemName: "bell")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fill)
                    }
                })
                
                NavigationLink(destination: SettingsView()) {
                    if(!viewModel.profileImage.size.width.isZero){
                        ZStack{
                            Text("")
                                .cornerRadius(20)
                                .frame(width: 40, height: 40)
                                .background(.black.opacity(0.2))
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                            
                            Image(uiImage: viewModel.profileImage)
                                .resizable()
                                .cornerRadius(20)
                                .frame(width: 30, height: 30)
                                .background(.black.opacity(0.2))
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                        }
                    } else {
                        ZStack{
                            Text("")
                                .cornerRadius(20)
                                .frame(width: 40, height: 40)
                                .background(.black.opacity(0.2))
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                            
                            Image(systemName: "person.circle")
                                .resizable()
                                .cornerRadius(20)
                                .frame(width: 20, height: 20)
                                .background(Color.black.opacity(0.2))
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
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
    }
    
    private func cardsAndSpeeDateSection(for geoReader: GeometryProxy) -> some View {
        ZStack{
            CardsView(updateData: $updateData, gotSwipedRecords: $gotSwipedRecords, viewModel: viewModel)
            plusButton()
            
            VStack{
                Text("Upcoming SpeedDate:")
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .font(.custom("Superclarendon", size: geoReader.size.height * 0.030))
                
          
                    NavigationLink(destination: SpeedDateHomeView(viewModel: viewModel, placeInLine: self.placeInLine, timeLeft: self.timeLeft, isStartVideoNow: $isStartVideoNow, isTimeEnded: $isTimeEnded) , label: {
                        CountdownTimerView( timeRemaining: !viewModel.speedDates.isEmpty &&
                                            //negative when eventDate passed current time and date
                                            (viewModel.speedDates.first!.eventDate.timeIntervalSinceNow.sign != .minus)  ? Int(viewModel.speedDates.first!.eventDate.timeIntervalSinceNow): timeLeft(inLine: self.placeInLine),
                            geoReader: geoReader,
                            isStartNow: $isStartSpeedDateNow,
                            isTimeEnded: $isTimeEnded,
                            speedDates: viewModel.speedDates
                        )
                    }).disabled(isStartSpeedDateNow == true ? false: true)
                
              
                
            }
            .padding(.top,geoReader.size.height * 0.05)
            .position(x: geoReader.frame(in: .local).midX, y: geoReader.size.height * 0.85)
        }
    }
    
    private func displayText() -> String{
        showFriendDisplay ? (profileText = "Friend Profile") : (profileText = "Dating Profile")
        return profileText;
    }
    
    private func getMatchRecordsForThisWeek(completed: @escaping(_ matches: [MatchRecordModel]) -> Void) {
        let matchDayString = viewModel.userProfile.matchDay.lowercased()
        let enumDayOfWeek = Date.Weekday(rawValue: matchDayString)
        
        let start = Date.today().previous(enumDayOfWeek!)
        let end = Date.today().next(enumDayOfWeek!)
        
        db.collection("matchRecords")
            .whereField("userProfileId", isEqualTo: viewModel.userProfile.id)
            .whereField("createdDate", isGreaterThan: start)
            .whereField("createdDate", isLessThan: end)
            .whereField("isNew", isEqualTo: false)
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
    
    private func getCardGroups(completed: @escaping(_ userCardGroup: SwipedCardGroupsModel) -> Void){
        // get your cardGroup for this week as well as 20 other random cardGroups
        let matchDayString = viewModel.userProfile.matchDay.lowercased()
        let enumDayOfWeek = Date.Weekday(rawValue: matchDayString)
        
        let start = Date.today().previous(enumDayOfWeek!)
        let end = Date.today().next(enumDayOfWeek!)
        
        getUserCardGroup(start:start, end: end){(userGroup) -> Void in
            if (userGroup.id != "") {
                getOtherCardGroups(start: start, end: end){(otherGroups) -> Void in
                    if(!otherGroups.isEmpty) {
                        completed(self.swipedCardGroups)
                    }
                }
            }
        }
    }
    
    private func getUserCardGroup(start: Date, end: Date, completed: @escaping(_ userGroup: SwipedCardGroupModel) -> Void){
        db.collection("swipedCardGroups")
            .whereField("profileId", isEqualTo: viewModel.userProfile.id)
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
                            //                            swipedCardFoo.userCardGroup = SwipedCardGroupModel(id: data["id"] as? String ?? "", profileId: data["profileId"] as? String ?? "", cardIds: data["cardIds"] as? [String] ?? [""], answers: data["answers"] as? [String] ?? [""])
                            
                            completed(self.swipedCardGroups.userCardGroup)
                        }
                    }
                }
            }
    }
    
    private func getOtherCardGroups(start: Date, end: Date, completed: @escaping(_ otherGroups: [SwipedCardGroupModel]) -> Void){
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
                            //                            swipedCardFoo.otherCardGroups.append(cardGroup)
                        }
                    }
                    completed(self.swipedCardGroups.otherCardGroups)
                }
            }
    }
    
    private func findMatches(cardGroups: SwipedCardGroupsModel, completed: @escaping(_ successFullMatches: [MatchRecordModel]) -> Void){
        let user = cardGroups.userCardGroup
        let others = cardGroups.otherCardGroups.filter{$0.profileId != user.profileId}
        var successMatchSnapshots: [CardGroupSnapShotModel] = []
        
        // looping through to get the each cardId with its answer(based on index)
        for (index,record) in user.cardIds.enumerated() {
            let userSnapshot = CardGroupSnapShotModel(id: UUID().uuidString, profileId: user.profileId, cardId: record, answer: user.answers[index])
            
            self.userMatchSnapshots.append(userSnapshot)
        }
        
        for(_, other) in others.enumerated() {
            for(otherIndex, otherItem) in other.cardIds.enumerated() {
                let othersSnapshot = CardGroupSnapShotModel(id: UUID().uuidString, profileId: other.profileId, cardId: otherItem, answer: other.answers[otherIndex])
                
                self.potentialMatchSnapshots.append(othersSnapshot)
            }
        }
        
        //main matching logic
        if(viewModel.successfullMatchSnapshots.isEmpty){
            for (_, record) in self.userMatchSnapshots.enumerated() {
                for(_, record2) in self.potentialMatchSnapshots.enumerated() {
                    if(record.cardId == record2.cardId && record.answer == record2.answer) {
                        successMatchSnapshots.append(record2)
                    }
                }
            }
            
            if(!successMatchSnapshots.isEmpty){
                let crossRef = Dictionary(grouping: successMatchSnapshots, by: \.profileId)
                let maximum = crossRef.max{a, b in a.value.count > b.value.count}
                if(maximum != nil){
                    let bestProfileId = maximum!.key
                    successMatchSnapshots.removeAll(where: { $0.profileId == bestProfileId} )
                }
                
                let crossRef2 = Dictionary(grouping: successMatchSnapshots, by: \.profileId)
                let maximum2 = crossRef2.max{a, b in a.value.count > b.value.count}
                
                if(maximum != nil && maximum2 != nil){
                    var cardsIds: [String] = []
                    var answers: [String] = []
                    maximum!.value.forEach({cardsIds.append($0.cardId)})
                    maximum!.value.forEach({answers.append($0.answer)})
                    
                    let firstMatch = MatchRecordModel(id: UUID().uuidString, userProfileId: user.profileId, matchProfileId: maximum!.key, cardIds: cardsIds, answers: answers, isNew: true)
                    
                    var cardsIds2: [String] = []
                    var answers2: [String] = []
                    maximum2!.value.forEach({cardsIds2.append($0.cardId)})
                    maximum2!.value.forEach({answers2.append($0.answer)})
                    
                    let secondMatch = MatchRecordModel(id: UUID().uuidString, userProfileId: user.profileId, matchProfileId: maximum2!.key, cardIds: cardsIds2, answers: answers2, isNew: true)
                    
                    viewModel.successfullMatchSnapshots.append(firstMatch)
                    viewModel.successfullMatchSnapshots.append(secondMatch)
                }
            }
            completed(viewModel.successfullMatchSnapshots)
        }
    }
    
    private func saveMatchRecords(matches: [MatchRecordModel]){
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
    
    private func plusButton() -> some View{
        GeometryReader{ geo in
            VStack{
                NavigationLink(destination: CreateCardsView(showCardCreatedAlert: $showCardCreatedAlert, userProfile: viewModel.userProfile)) {
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
            .position(x: geo.size.height * 0.09, y: geo.size.width * 1.2)
        }
    }
    
    private func timeLeft(inLine: Int) -> Int{
        //orginal date host scheduled
        
        if !viewModel.speedDates.isEmpty {
            let eventDate = viewModel.speedDates.first!.eventDate
            let calendar = Calendar.current
            
            //every match gets a 10 minute window to join videoRoom
            let tenMinsLater = calendar.date(byAdding: .minute, value: 10, to: eventDate)
            let twentyMinsLater = calendar.date(byAdding: .minute, value: 20, to: eventDate)
            let thirtyMinsLater = calendar.date(byAdding: .minute, value: 30, to: eventDate)
            let fourtyMinsLater = calendar.date(byAdding: .minute, value: 40, to: eventDate)
            let fourtyFiveMinsLater = calendar.date(byAdding: .minute, value: 45, to: eventDate)
            
            //compares the times to the current date and time(if negative then time has passsed current time)
            let peer1StartDate = tenMinsLater!.timeIntervalSinceNow
            let peer1EndDate = twentyMinsLater!.timeIntervalSinceNow
            
            let peer2StartDate = twentyMinsLater!.timeIntervalSinceNow
            let peer2EndDate = twentyMinsLater!.timeIntervalSinceNow
            
            let peer3StartDate = thirtyMinsLater!.timeIntervalSinceNow
            let peer3EndDate = fourtyMinsLater!.timeIntervalSinceNow
            
            let EndDate = fourtyFiveMinsLater!.timeIntervalSinceNow
            
            //based on where matches are in line, if there window to join has passed we disable the button
            switch inLine{
            case 1:
                do {
                    let peerStart1 = Int(peer1StartDate)
                    
                    if peer1StartDate.sign != .minus {
                        self.timeLeft = peerStart1
                        return 0
                    } else if peer1EndDate.sign != .minus {
                        self.timeLeft = 0
                        return 0
                        
                    } else {
                        self.timeLeft = 0
                        self.isTimeEnded = true
                        return 0
                    }
                }
            case 2:
                do {
                    let peerStart2 = Int(peer2StartDate)
                    
                    if peer2StartDate.sign != .minus {
                        self.timeLeft = peerStart2
                        return 0
                    }  else if peer2EndDate.sign != .minus {
                        self.timeLeft = 0
                        return 0
                        
                    } else {
                        self.timeLeft = 0
                        self.isTimeEnded = true
                        return 0
                    }
                }
            case 3:
                do {
                    let peerStart3 = Int(peer3StartDate)
                    
                    if peer3StartDate.sign != .minus {
                        self.timeLeft = peerStart3
                        return 0
                    } else if peer3EndDate.sign != .minus {
                        self.timeLeft = 0
                        return 0
                    } else {
                        self.timeLeft = 0
                        self.isTimeEnded = true
                        return 0
                    }
                }
            case 5:
                do {
                    if EndDate.sign == .minus {
                        self.timeLeft = 0
                        self.isStartSpeedDateNow = false
                        viewModel.speedDates.remove(at: 0)
                        return 0
                    }
                }
            default:
                break
                
            }
            
        }
       
        return 0
    }
    
    private func setPlaceInLine(completed: @escaping(_ placeIn: Int) -> Void) {
        let placeInLine = viewModel.speedDates.first!.matchProfileIds.firstIndex(of: viewModel.userProfile.id) ?? 4
        
        // remove 0 based index
        self.placeInLine = placeInLine.advanced(by: 1)
        completed(self.placeInLine)
    }
    
    //    private func addspeedDate() {
    //            let docRefs = db.collection("speedDates")
    //
    //            let id = UUID().uuidString;
    //            docRefs.document(id).setData([
    //                "id": id,
    //                "roomId": "",
    //                "matchProfileIds":["EF7C8A72-87C1-4FD5-ABFE-D458C0D86E90","653EB-C44D-4C3F-888F-45B9A6B08B","D5B6-C4D-43F-88F-45B9A6BE4"],
    //                "eventDate": Timestamp(date: Date()),
    //                "createdDate": Timestamp(date: Date())
    //            ])
    //    }
} 

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
