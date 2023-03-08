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
    
    @State private var showFriendDisplay = false
    @State private var progress: Double = 0.0
    @State private var valuesCount = 0.0
    @State private var littleThingsCount = 0.0
    @State private var personalityCount = 0.0
    @State private var showCardCreatedAlert: Bool = false
    @State private var image = UIImage()
    @State private var profileText = ""
    @State private var updateData: Bool = false
    @State private var cards: [CardModel] = []
    @State private var lastDoc: Any = []
    @State private var swipedCards: [SwipedCardModel] = []
    @State private var cardsNotSwiped: [CardModel] = []
    @State private var cardsForProgressCircle: [CardModel] = []
    
    @State private var profileImage: UIImage = UIImage()
    
    
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
                        getStorageFile()
                        // keep on forgetting but you gotta swipe cards today/this week to have  profiler display data
                        getCardsSwipedToday() {(swipedCards) -> Void in
                            if !swipedCards.isEmpty {
                                getCardFromIds(swipedCards: swipedCards)
                            }
                        }
                    }
                    .onChange(of: updateData) { _ in
                        getCardsSwipedToday() {(swipedCards) -> Void in
                            if !swipedCards.isEmpty {
                                getCardFromIds(swipedCards: swipedCards)
                            }
                        }
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
                Image(uiImage: self.profileImage)
                    .resizable()
                    .cornerRadius(20)
                    .frame(width: 50, height: 50)
                    .background(Color.black.opacity(0.2))
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .padding(.leading, geoReader.size.width * 0.8)
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
            CardsView(updateData: $updateData)
            VStack{
                NavigationLink(destination: CreateCardsView(showCardCreatedAlert: $showCardCreatedAlert)) {
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
    
    public func getCardsSwipedToday(completed: @escaping (_ cardIds: [SwipedCardModel]) -> Void) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let start = calendar.date(from: components)!
        let end = calendar.date(byAdding: .day, value: 1, to: start)!
        
        db.collection("swipedCards")
            .whereField("userId", isEqualTo: Auth.auth().currentUser?.uid as Any)
            .whereField("swipedDate", isGreaterThan: start)
            .whereField("swipedDate", isLessThan: end)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        
                        if !data.isEmpty{
                            let swipedCard = SwipedCardModel(id: document.documentID, answer: data["answer"] as? String ?? "", cardId: data["cardId"] as? String ?? "")
                            
                            self.swipedCards.append(swipedCard)
                        }
                    }
                    
                    completed(self.swipedCards)
                }
            }
    }
    
    private func getCardFromIds(swipedCards: [SwipedCardModel]) {
        var cardIds = getUniqueCards(swipedCards: swipedCards)
        var batches: [Any] = []
        var results: [CardModel] = []
        
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
                    .whereField("id", in: batch)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                let data = document.data()
                                
                                if !data.isEmpty{
                                    let card = CardModel(id: document.documentID, question: data["question"] as? String ?? "", choices: data["choices"] as? [String] ?? [""], categoryType: data["categoryType"] as? String ?? "", profileType: data["profileType"] as? String ?? "")
                                    
                                    self.cardsNotSwiped.append(card)
                                    self.cardsForProgressCircle.append(card)
                                }
                                print("in while loop",self.littleThingsCount)
                            }
                            updateProfilerBars(otherSwipedCards: self.cardsNotSwiped)
                            self.cardsNotSwiped.removeAll()
                        }
                    }
            )
        }
    }
    
    private func getUniqueCards(swipedCards: [SwipedCardModel]) -> [String] {
        var cardIds: [String] = []
        let answeredCards = swipedCards.filter{$0.answer != ""}
        //you shouldnt get the same answered card twice but just in case make it unique
        let uniqueCards = answeredCards.unique{$0.cardId}
        
        for card in uniqueCards {
            cardIds.append(card.cardId)
        }
        return cardIds
    }
    
    private func clearStates(){
        self.cardsNotSwiped.removeAll()
        self.cardsForProgressCircle.removeAll()
        self.valuesCount = 0
        self.littleThingsCount = 0
        self.personalityCount = 0
    }
    
    private func updateProfilerBars(otherSwipedCards: [CardModel]){
        if(!otherSwipedCards.isEmpty){
            for card in otherSwipedCards {
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
    
    private func displayText() -> String{
        showFriendDisplay ? (profileText = "Friend Profile") : (profileText = "Dating Profile")
        return profileText;
    }
    
    private func setProgress() -> Double{
        // 1.0 fully fills up the circle
        self.progress = Double(self.cardsForProgressCircle.count) * 0.05
        
        return Double(self.cardsForProgressCircle.count) * 0.05
    }
} 

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
