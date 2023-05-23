//
//  HomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/18/23.
//

import SwiftUI

import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import FirebaseFunctions
import FirebaseMessaging
import UIKit

struct HomeView: View {
    @StateObject public var viewModel = HomeViewModel()
    @ObservedObject private var messageViewModel = MessageViewModel()
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var showCardCreatedAlert: Bool = false
    @State private var profileText: String = ""
    @State private var updateData: Bool = false
    @State private var gotSwipedRecords: Bool = false
    @State private var cards: [CardModel] = []
    @State private var userMatchSnapshots: [CardGroupSnapShotModel] = []
    @State private var potentialMatchSnapshots: [CardGroupSnapShotModel] = []
    
    @State private var showingInstructionsPopover: Bool = false
    @State private var showingBasicInfoPopover: Bool = false
    @State private var showHamburgerMenu: Bool = false
    @State private var isStartSpeedDateNow: Bool = false
    @State private var isStartVideoNow: Bool = false
    @State private var isTimeEnded: Bool = false
    @State private var placeInLine: Int = 0
    @State private var timeRemainingSpeedDateHomeView: Int = 0
    @State private var isPeerButtonDisabled: Bool = false
    @State private var timeRemainingHomeView: Int = 0
    @State private var circleColorChanged = false
    @State private var heartColorChanged = false
    @State private var heartSizeChanged = false
    @State private var textOpacityChanged = false
    @State private var launchJoinRoom = false
    @State private var hasPeerJoined = false
    @State private var showCards = false
    @State private var emptyRooms: [RoomModel] = []
    @State private var timeRemainingg = 10
    
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    let functions = Functions.functions()
    
    var body: some View {
        NavigationView{
            GeometryReader{geoReader in
                ZStack{
                    ZStack{
                        FacetimeView(homeViewModel: viewModel, launchJoinRoom: $launchJoinRoom, hasPeerJoined: $hasPeerJoined)
                        headerSection(for: geoReader)
                                             .padding(.leading, geoReader.size.width * 0.25)
                      
                        
                        if !hasPeerJoined {
                            animatedThingy(for: geoReader)
                        }
                        
            
                        if self.showCards {
                            cardsAndSpeeDateSection(for: geoReader)
                                .padding(.top,10)
                                .animation(.default)
                        } 
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
                .ignoresSafeArea(edges: .top)
                .position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY )
                .alert(isPresented: $showCardCreatedAlert){
                    Alert(
                        title: Text("New Card Created!"),
                        message: Text("You'll get a notification if someone matches your perfered answer!")
                    )
                }
                .onAppear {
                    getAllData()
                    getAvailableRoom()
                  
                       
                    
                    
                }
//                .onReceive(timer) { time in
//                    if timeRemainingg > 0 {
//                        timeRemainingg -= 1
//                    } else if timeRemainingg == 0 {
//                        if self.showCards == false {
//                            self.showCards = true
//                        }
//
//                    }
//                }
                .onChange(of: updateData) { _ in
                    saveCards()
                }
                .popover(isPresented: $showingBasicInfoPopover) {
                    BasicInfoPopoverView(userProfile: $viewModel.userProfile,profileImage: $viewModel.profileImage,showingBasicInfoPopover: $showingBasicInfoPopover, showingInstructionsPopover: $showingInstructionsPopover)
                }
//                .navigationBarItems(leading: (
//                    headerSection(for: geoReader)
//                        .padding(.leading, geoReader.size.width * 0.25)
//                ))
            }
        }
    }
    
    private func getAllData() {
        getProfileAndRecords() {(getProfileId) -> Void in
            if getProfileId != "" {
                viewModel.saveMessageToken()
                getMatchData()
                viewModel.getSpeedDate(speedDateIds: viewModel.userProfile.speedDateIds) {(speedDates) -> Void in
                    if !speedDates.isEmpty {
                        setPlaceInLine(){(placeIn) -> Void in
                            if placeIn != 0 {
                                setTimeRemaining(){(timeRemaining) -> Void in
                                    if timeRemaining != 0 {
                                        timeLeft(inLine: placeIn)
                                    }
                                }
                                
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
        let format = DateFormatter()
        //The -1 is added at the end because Calendar.current.component(.weekday, from: Date()) returns values from 1-7 but weekdaySymbols expects array indices
        let weekday = format.weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1]
        
        if(weekday == viewModel.userProfile.matchDay && viewModel.successfullMatchSnapshots.isEmpty) {
            viewModel.getMatchRecordsForPreviousWeek() {(matchRecordsPreviousWeek) -> Void in
                // If theres no matchRecords for this week run match logic and find matches
                if matchRecordsPreviousWeek.isEmpty {
                    getCardGroups() {(userCardGroup) -> Void in
                        if !userCardGroup.userCardGroup.id.isEmpty {
                            findMatches(cardGroups: userCardGroup) {(successFullMatches) -> Void in
                                if !successFullMatches.isEmpty {
                                    viewModel.saveMatchRecords(matches: successFullMatches)
                                    //delaying routing to make sure matchRecords save
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                        viewRouter.currentPage = .matchPage
                                    }
                                }
                            }
                        }
                    }
                } else if matchRecordsPreviousWeek.contains(where: { mrec in mrec.isNew == true}) {
                    viewRouter.currentPage = .matchPage
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
                        // fires off getAllCards() in CardView
                        gotSwipedRecords.toggle()
                        if !swipedRecords.isEmpty {
                            viewModel.getSwipedCardsFromSwipedRecords(swipedRecords: swipedRecords)
                        }
                        completed(profileId)
                    }
                } else {
                    viewModel.createUserProfile() {(createdUserProfileId) -> Void in
                        if createdUserProfileId != "" {
                            // fires off getAllCards() in CardView
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
                HStack{
                    Image("logo")
                        .resizable()
                        .frame(width: 40, height: 40)
                    //.background(Color.mainBlack)
                       // .position(x: geoReader.size.width * -0.35, y: geoReader.size.height * 0.03)
                    
                    Text("iceBreakrrr")
                        .font(.custom("Georgia-BoldItalic", size: geoReader.size.height * 0.03))
                        .bold()
                        .foregroundColor(Color.iceBreakrrrBlue)
                       // .position(x: geoReader.size.width * 0.3, y: geoReader.size.height * 0.03)
                }
                
                HStack{
                   // .position(x: geoReader.size.height * -0.08, y: geoReader.size.height * 0.03)
    //
    //                Spacer()
    //                    .frame(width: geoReader.size.width * 0.55)

                    NavigationLink(destination: NotificationsView(), label: {
                        ZStack{
                            Text("")
                                .cornerRadius(20)
                                .frame(width: 40, height: 40)
                                .background(Color.black.opacity(0.6))
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())

                            Image(systemName: "bell")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fill)
                        }
                        //.position(y: geoReader.size.height * 0.03)
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
                                    .background(.black.opacity(0.6))
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())

                                Image(systemName: "person.circle")
                                    .resizable()
                                    .cornerRadius(20)
                                    .frame(width: 20, height: 20)
                                    .background(Color.black.opacity(0.6))
                                    .foregroundColor(.white)
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
            }
            .position(x: geoReader.size.width * 0.3, y: geoReader.size.height * 0.08)
            
            Button(action: {
                withAnimation{
                    self.showHamburgerMenu.toggle()
                }
            }) {
                ZStack{
                    Text("")
                        .frame(width: 35, height: 35)
                     .background(Color.black.opacity(0.6))
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
            .position(x: geoReader.size.height * -0.09, y: geoReader.size.height * 0.08)
        }
    }
    
    private func animatedThingy(for geoReader: GeometryProxy) -> some View {
        
        VStack{
            VStack{
                    Text("Searching for")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .opacity(textOpacityChanged ? 1 : 0.1)
                        .animation(Animation.linear(duration: 1).repeatForever())
                    
                    Text("SpeedDate")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .opacity(textOpacityChanged ? 1 : 0.1)
                        .animation(Animation.linear(duration: 1).repeatForever())
                
               
//
//                Text("...")
//                    .font(.system(size: 30))
//                    .foregroundColor(.white)
//                    .opacity(textOpacityChanged ? 1 : 0.1)
//                    .animation(Animation.linear(duration: 1).repeatForever())
            }
            
//            Spacer()
//                .frame(height: 4)
           
            
            ZStack {
                Circle()
                    .frame(width: 125, height: 125)
                    .foregroundColor(circleColorChanged ? Color(.systemGray5) : .iceBreakrrrBlue)
                    .animation(Animation.linear(duration: 1).repeatForever())
                
                Image(systemName: "heart.fill")
                    .foregroundColor(heartColorChanged ? .iceBreakrrrBlue : .white)
                    .font(.system(size: 75))
                    .scaleEffect(heartSizeChanged ? 1.0 : 0.5)
                    .animation(Animation.linear(duration: 1).repeatForever())
            }
            .onAppear {
                self.circleColorChanged.toggle()
                self.heartColorChanged.toggle()
                self.heartSizeChanged.toggle()
                self.textOpacityChanged.toggle()
            }
        }
       
    }
    
    private func cardsAndSpeeDateSection(for geoReader: GeometryProxy) -> some View {
        ZStack{
            CardsView(updateData: $updateData, gotSwipedRecords: $gotSwipedRecords, viewModel: viewModel)
                .position(x: geoReader.frame(in: .local).midX, y:  geoReader.size.height * 0.7)
           // plusButton()
            
//            VStack{
//                Text("Upcoming SpeedDate:")
//                    .bold()
//                    .multilineTextAlignment(.center)
//                    .foregroundColor(.white)
//                    .font(.custom("Superclarendon", size: geoReader.size.height * 0.030))
//
//                //CountDownButton
//                NavigationLink(destination: SpeedDateHomeView(viewModel: viewModel, placeInLine: self.placeInLine, timeRemainingSpeedDateHomeView: $timeRemainingSpeedDateHomeView, isStartVideoNow: $isStartVideoNow, isTimeEnded: $isTimeEnded) , label: {
//                    CountdownTimerView( timeRemaining: $timeRemainingHomeView,
//                                        geoReader: geoReader,
//                                        isStartNow: $isStartSpeedDateNow,
//                                        isTimeEnded: $isTimeEnded,
//                                        speedDates: viewModel.speedDates
//                    )
//                }).disabled(isStartSpeedDateNow == true ? false: true)
//            }
//            .padding(.top,geoReader.size.height * 0.05)
//            .position(x: geoReader.frame(in: .local).midX, y: geoReader.size.height * 0.85)
        }
    }
    
    private func getCardGroups(completed: @escaping(_ userCardGroup: SwipedCardGroupsModel) -> Void){
        // get your cardGroup for this week as well as 20 other random cardGroups
        let matchDay = viewModel.userProfile.matchDay == "Pick MatchDay" ? "Sunday" : viewModel.userProfile.matchDay
        
        //SWITCH TO PREVENT PREVIEW CRASHING
        //let matchDay = "Monday"
        
        let matchDayString = matchDay.lowercased()
        let enumDayOfWeek = Date.Weekday(rawValue: matchDayString)
        
        
        let start = Date.today().previous(enumDayOfWeek!).previous(enumDayOfWeek ?? .sunday)
        let end = Date.today()
        
        viewModel.getUserCardGroup(start:start, end: end){(userGroup) -> Void in
            if userGroup.id != "" {
                viewModel.getOtherCardGroups(start: start, end: end){(otherGroups) -> Void in
                    if !otherGroups.isEmpty {
                        completed(viewModel.swipedCardGroups)
                    }
                }
            }
        }
    }
    
    private func findMatches(cardGroups: SwipedCardGroupsModel, completed: @escaping(_ successFullMatches: [MatchRecordModel]) -> Void){
        let user = cardGroups.userCardGroup
        // your filter this twice once in the db call. Okay I guess
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
                
                if(maximum2 != nil){
                    let bestProfileId2 = maximum2!.key
                    successMatchSnapshots.removeAll(where: { $0.profileId == bestProfileId2} )
                }
                
                let crossRef3 = Dictionary(grouping: successMatchSnapshots, by: \.profileId)
                let maximum3 = crossRef3.max{a, b in a.value.count > b.value.count}
                
                if maximum != nil {
                    var cardsIds: [String] = []
                    var answers: [String] = []
                    maximum!.value.forEach({cardsIds.append($0.cardId)})
                    maximum!.value.forEach({answers.append($0.answer)})
                    
                    let firstMatch = MatchRecordModel(id: UUID().uuidString, userProfileId: user.profileId, matchProfileId: maximum!.key, cardIds: cardsIds, answers: answers, isNew: true)
                    
                    viewModel.successfullMatchSnapshots.append(firstMatch)
                }
                
                if maximum2 != nil {
                    var cardsIds2: [String] = []
                    var answers2: [String] = []
                    maximum2!.value.forEach({cardsIds2.append($0.cardId)})
                    maximum2!.value.forEach({answers2.append($0.answer)})
                    
                    let secondMatch = MatchRecordModel(id: UUID().uuidString, userProfileId: user.profileId, matchProfileId: maximum2!.key, cardIds: cardsIds2, answers: answers2, isNew: true)
                    
                    viewModel.successfullMatchSnapshots.append(secondMatch)
                }
                
                if maximum3 != nil {
                    var cardsIds3: [String] = []
                    var answers3: [String] = []
                    maximum3!.value.forEach({cardsIds3.append($0.cardId)})
                    maximum3!.value.forEach({answers3.append($0.answer)})
                    
                    let thirdMatch = MatchRecordModel(id: UUID().uuidString, userProfileId: user.profileId, matchProfileId: maximum3!.key, cardIds: cardsIds3, answers: answers3, isNew: true)
                    
                    viewModel.successfullMatchSnapshots.append(thirdMatch)
                }
            }
            completed(viewModel.successfullMatchSnapshots)
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
                        self.timeRemainingSpeedDateHomeView = peerStart1
                        return 0
                    } else if peer1EndDate.sign != .minus {
                        self.timeRemainingSpeedDateHomeView = 0
                        return 0
                        
                    } else {
                        self.timeRemainingSpeedDateHomeView = 0
                        self.isTimeEnded = true
                        return 0
                    }
                }
            case 2:
                do {
                    let peerStart2 = Int(peer2StartDate)
                    
                    if peer2StartDate.sign != .minus {
                        self.timeRemainingSpeedDateHomeView = peerStart2
                        return 0
                    }  else if peer2EndDate.sign != .minus {
                        self.timeRemainingSpeedDateHomeView = 0
                        return 0
                        
                    } else {
                        self.timeRemainingSpeedDateHomeView = 0
                        self.isTimeEnded = true
                        return 0
                    }
                }
            case 3:
                do {
                    let peerStart3 = Int(peer3StartDate)
                    
                    if peer3StartDate.sign != .minus {
                        self.timeRemainingSpeedDateHomeView = peerStart3
                        return 0
                    } else if peer3EndDate.sign != .minus {
                        self.timeRemainingSpeedDateHomeView = 0
                        return 0
                    } else {
                        self.timeRemainingSpeedDateHomeView = 0
                        self.isTimeEnded = true
                        return 0
                    }
                }
            case 5:
                do {
                    if EndDate.sign == .minus {
                        self.timeRemainingSpeedDateHomeView = 0
                        self.isStartSpeedDateNow = false
                        self.isTimeEnded = true
                        viewModel.removeSpeedDate()
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
    
    private func setTimeRemaining(completed: @escaping(_ timeRemaining: Int) -> Void) {
        if !viewModel.speedDates.isEmpty{
            let rawEventDate = viewModel.speedDates.first!.eventDate
            let calendar = Calendar.current
            let calendarEventDate = calendar.date(byAdding: .minute, value: 0, to: rawEventDate)
            let eventDate = calendarEventDate!.timeIntervalSinceNow
            
            if eventDate.sign != .minus {
                self.timeRemainingHomeView = Int(eventDate)
                completed(Int(eventDate))
            }
            completed(-1)
        }
        completed(-1)
    }
    
    private func getAvailableRoom(){
        getActiveSessions() {(activeSessions) -> Void in
            if !activeSessions.data.isEmpty {
                findRoom(activeSessions: activeSessions)
            } else {
                getAllRooms() { (allRooms) -> Void in
                    if !allRooms.data.isEmpty {
                        viewModel.currentSpeedDate.roomId = allRooms.data.first!.id
                        retrieveCodes()
                        
                    }
                }
            }
        }
    }
    
    private func findRoom(activeSessions: Response ){
        filterRooms(activeSessions: activeSessions.data) {(openRoom) -> Void in
            if (openRoom != "") && (openRoom != "Gender is null") {
                retrieveCodes()
            } else if openRoom == "Gender is null"{
                //Alert gender is null
            } else {
                /// need to filter out the active sessionss
                getAllRooms() { (allRooms) -> Void in
                    if !allRooms.data.isEmpty {
                        allRooms.data.forEach{ room in
                            activeSessions.data.forEach{ actSesh in
                                if room.id != actSesh.room_id {
                                    emptyRooms.append(room)
                                }
                            }
                        }
                        if !emptyRooms.isEmpty {
                            viewModel.currentSpeedDate.roomId = emptyRooms.first!.id
                            retrieveCodes()
                        }
                    } else {
                        createRoom(){ (roomId) -> Void in
                            if roomId != "" {
                                retrieveCodes()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func retrieveCodes(){
        getRoomCodes(){ (roomCodes) -> Void in
            if !roomCodes.data.isEmpty {
                roomCodes.data.forEach{ x in
                    if x.role == "male"{
                        viewModel.currentSpeedDate.maleRoomCode = x.code
                    } else if x.role == "female" {
                        viewModel.currentSpeedDate.femaleRoomCode = x.code
                    }
                }
                launchJoinRoom.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showCards.toggle()
                        
                }
            }
            else {
                createRoomCodes() {(newRoomCodes) -> Void in
                    if !newRoomCodes.data.isEmpty {
                        newRoomCodes.data.forEach{ x in
                            if x.role == "male"{
                                viewModel.currentSpeedDate.maleRoomCode = x.code
                            } else if x.role == "female" {
                                viewModel.currentSpeedDate.femaleRoomCode = x.code
                            }
                        }
                        launchJoinRoom.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showCards.toggle()
                        }
                    }
                }
            }
        }
    }
    
    private func getActiveSessions(completed: @escaping(_ activeSessions: Response) -> Void){
        guard let url = URL(string: "https://us-central1-projectdate-a365b.cloudfunctions.net/getActiveSessions") else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                completed(Response(data: []))
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let actSessions = try JSONDecoder().decode(Response.self, from: data)
                        completed(actSessions)
                    } catch let error {
                        print("Error decoding: ", error)
                        completed(Response(data: []))
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    private func filterRooms(activeSessions: [ActiveSessionModel] ,completed: @escaping(_ openRoom: String) -> Void){
        activeSessions.forEach{ x in
            // making sure there's no more than 1 peer before joining room
            if x.peers.count == 1 {
                if viewModel.userProfile.gender != "" {
                    // gender and role cant be the same
                    if  x.peers.first!.value.role != viewModel.userProfile.gender.lowercased() {
                        viewModel.currentSpeedDate.roomId = x.room_id
                        completed(viewModel.currentSpeedDate.roomId)
                    }
                } else {
                    completed("Gender is null")
                }
            }
        }
        completed("")
    }
    
    private func createRoom(completed: @escaping (_ roomId: String) -> Void) {
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
                    do {
                        //let decodedUsers = try JSONDecoder().decode(Response.self, from: data)
                        let roomId = String(data:data, encoding: .utf8)
                        viewModel.currentSpeedDate.roomId = roomId!
                        completed(viewModel.currentSpeedDate.roomId)
                    } catch let error {
                        completed("")
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    private func getRoomCodes(completed: @escaping (_ roomCodes: RolesModel) -> Void) {
        guard let url = URL(string: "https://us-central1-projectdate-a365b.cloudfunctions.net/getRoomCodes?room_id=\(viewModel.currentSpeedDate.roomId)") else { fatalError("Missing URL") }
        
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
    
    private func createRoomCodes(completed: @escaping (_ newRoomCodes: RolesModel) -> Void) {
        guard let url = URL(string: "https://us-central1-projectdate-a365b.cloudfunctions.net/createRoomCodes?room_id=\(viewModel.currentSpeedDate.roomId)") else { fatalError("Missing URL") }
        
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
    
    private func getAllRooms(completed: @escaping(_ allRooms: getAllRoomsResponse) -> Void){
        guard let url = URL(string: "https://us-central1-projectdate-a365b.cloudfunctions.net/getAllRooms") else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                completed(getAllRoomsResponse(data: []))
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let rooms = try JSONDecoder().decode(getAllRoomsResponse.self, from: data)
                        completed(rooms)
                    } catch let error {
                        print("Error decoding: ", error)
                        completed(getAllRoomsResponse(data: []))
                    }
                }
            }
        }
        dataTask.resume()
    }
}


struct Response: Codable{
    var data: [ActiveSessionModel]
}

struct ActiveSessionModel: Codable{
    var id: String
    var room_id: String
    var active: Bool
    var peers: [String:PeerModel]
}

struct PeerModel: Codable{
    var id: String
    var name: String
    var role: String
}

struct getAllRoomsResponse: Codable{
    var data: [RoomModel]
}

struct RoomModel: Codable{
    var id: String
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
