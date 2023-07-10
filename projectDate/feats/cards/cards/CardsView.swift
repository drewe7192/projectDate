//
//  testView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import SwiftUI

import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage
import UIKit

struct CardsView: View {
    @State var cards: [CardModel] = []
    @State var lastDoc: DocumentSnapshot!
    
    @Binding var updateData: Bool
    @Binding var gotSwipedRecords: Bool

    let viewModel: LiveViewModel
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(Array(self.cards.enumerated()), id: \.offset) { index, card in
                    //becuase of forEach in Zstack cards are stacked on top of each other
                    //[10,9,8,7,6,5,4,3,2,1,0] : index is reversed
                    //displays only "first" 4 cards at a time
                    if index > self.cards.count - 4 {
                        CardView(
                            card: card,
                            index: index,
                            // as cards are removed from stack index will decrement
                            onRemove: {
                                removedUser in
                                
                                self.cards.removeAll { $0.id == removedUser.id }
                            },
                            updateData: $updateData,
                            userProfile: viewModel.userProfile
                        )
                        .animation(.spring())
                        .frame(width:
                                self.cards.cardWidth(in: geometry,
                                                     cardId: index), height: geometry.size.height *  1.1)
                        .offset(x: 0,
                                y: self.cards.cardOffset(
                                    cardId: index))
                    }
                }
                .onChange(of: updateData) { newValue in
                    getAllCards(isUpdating: true)
                }
            }
            .onChange(of: gotSwipedRecords ){ newValue in
                getAllCards(isUpdating: false)
            }
        }
        .padding(.leading,13)
        .padding(.trailing,6)
    }
    
    private func getAllCards(isUpdating: Bool){
        var cardIdsFromSwipedRecords: [String] = []
        var query: Query!
        var batches: [Any] = []
        var batch: [String] = []
        
        for record in viewModel.swipedRecords {
            cardIdsFromSwipedRecords.append(record.cardId)
        }
      
        //workaround for the Firebase Query "IN" Limit of 10
        while(!cardIdsFromSwipedRecords.isEmpty){
            //splice Array: get first 10 and remove the same 10 from array
             batch = Array(cardIdsFromSwipedRecords.prefix(10))
            let count = cardIdsFromSwipedRecords.count
            if count < 10{
                cardIdsFromSwipedRecords.removeSubrange(ClosedRange(uncheckedBounds: (lower: 0, upper: count - 1)))
            } else{
                cardIdsFromSwipedRecords.removeSubrange(ClosedRange(uncheckedBounds: (lower: 0, upper: 9)))
            }
        }
        
        
            
            //pagination: get first n cards or get the next n cards
            if !isUpdating {
                if !batch.isEmpty {
                    query = db.collection("cards").limit(to: 10)
                        .whereField("id", notIn: batch)
                } else {
                    query = db.collection("cards").limit(to: 10)
                }
              
            } else {
                if (self.lastDoc != nil) {
                    if !batch.isEmpty {
                        query = db.collection("cards").start(afterDocument: self.lastDoc).limit(to: 10)
                            .whereField("id", notIn: batch)
                    } else {
                        query = db.collection("cards").start(afterDocument: self.lastDoc).limit(to: 10)
                    }
                   
                }
            }
            
            batches.append(
                query
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                let data = document.data()
                                
                                if !data.isEmpty{
                                    let card = CardModel(id: data["id"] as? String ?? "", question: data["question"] as? String ?? "", choices: data["choices"] as? [String] ?? [""], categoryType: data["categoryType"] as? String ?? "", profileType: data["profileType"] as? String ?? "")
                                    
                                    self.cards.append(card)
                                }
                            }
                            //important so we can get the next n cards from the db
                            self.lastDoc = querySnapshot!.documents.last
                        }
                    }
            )
    }
}

//
//private func plusButton() -> some View{
//    GeometryReader{ geo in
//        VStack{
//            NavigationLink(destination: CreateCardsView(showCardCreatedAlert: $showCardCreatedAlert, userProfile: viewModel.userProfile)) {
//                ZStack{
//                    Circle()
//                        .foregroundColor(Color.mainBlack)
//                        .frame(width: geo.size.width * 0.2, height: geo.size.width * 0.2)
//                        .shadow(radius: 10)
//
//                    Image(systemName:"plus")
//                        .resizable()
//                        .foregroundColor(Color.iceBreakrrrBlue)
//                        .frame(width: 50, height: 50)
//                }
//            }
//        }
//        .position(x: geo.size.height * 0.09, y: geo.size.width * 1.2)
//    }
//}

//private func getCardGroups(completed: @escaping(_ userCardGroup: SwipedCardGroupsModel) -> Void){
//    // get your cardGroup for this week as well as 20 other random cardGroups
//    let matchDay = "Sunday"
//    let matchDayString = matchDay.lowercased()
//    let enumDayOfWeek = Date.Weekday(rawValue: matchDayString)
//
//    let start = Date.today().previous(enumDayOfWeek!).previous(enumDayOfWeek ?? .sunday)
//    let end = Date.today()
//
//    viewModel.getUserCardGroup(start:start, end: end){(userGroup) -> Void in
//        if userGroup.id != "" {
//            viewModel.getOtherCardGroups(start: start, end: end){(otherGroups) -> Void in
//                if !otherGroups.isEmpty {
//                    completed(viewModel.swipedCardGroups)
//                }
//            }
//        } else {
//            completed(SwipedCardGroupsModel(id: "", userCardGroup: SwipedCardGroupModel(id: "", profileId: "", cardIds: [], answers: [], gender: ""), otherCardGroups: []))
//        }
//    }
//}
//
//private func findMatches(cardGroups: SwipedCardGroupsModel, completed: @escaping(_ successFullMatches: [MatchRecordModel]) -> Void){
//    let user = cardGroups.userCardGroup
//    // your filter this twice once in the db call. Okay I guess
//    let others = cardGroups.otherCardGroups.filter{$0.profileId != user.profileId}
//    var successMatchSnapshots: [CardGroupSnapShotModel] = []
//
//    // looping through to get the each cardId with its answer(based on index)
//    for (index,record) in user.cardIds.enumerated() {
//        let userSnapshot = CardGroupSnapShotModel(id: UUID().uuidString, profileId: user.profileId, cardId: record, answer: user.answers[index])
//
//        self.userMatchSnapshots.append(userSnapshot)
//    }
//
//    for(_, other) in others.enumerated() {
//        for(otherIndex, otherItem) in other.cardIds.enumerated() {
//            let othersSnapshot = CardGroupSnapShotModel(id: UUID().uuidString, profileId: other.profileId, cardId: otherItem, answer: other.answers[otherIndex])
//
//            self.potentialMatchSnapshots.append(othersSnapshot)
//        }
//    }
//
//    //main matching logic
//    if(viewModel.successfullMatchSnapshots.isEmpty){
//        for (_, record) in self.userMatchSnapshots.enumerated() {
//            for(_, record2) in self.potentialMatchSnapshots.enumerated() {
//                if(record.cardId == record2.cardId && record.answer == record2.answer) {
//                    successMatchSnapshots.append(record2)
//                }
//            }
//        }
//
//        if(!successMatchSnapshots.isEmpty){
//            let crossRef = Dictionary(grouping: successMatchSnapshots, by: \.profileId)
//            let maximum = crossRef.max{a, b in a.value.count > b.value.count}
//
//            if(maximum != nil){
//                let bestProfileId = maximum!.key
//                successMatchSnapshots.removeAll(where: { $0.profileId == bestProfileId} )
//            }
//
//            let crossRef2 = Dictionary(grouping: successMatchSnapshots, by: \.profileId)
//            let maximum2 = crossRef2.max{a, b in a.value.count > b.value.count}
//
//            if(maximum2 != nil){
//                let bestProfileId2 = maximum2!.key
//                successMatchSnapshots.removeAll(where: { $0.profileId == bestProfileId2} )
//            }
//
//            let crossRef3 = Dictionary(grouping: successMatchSnapshots, by: \.profileId)
//            let maximum3 = crossRef3.max{a, b in a.value.count > b.value.count}
//
//            if maximum != nil {
//                var cardsIds: [String] = []
//                var answers: [String] = []
//                maximum!.value.forEach({cardsIds.append($0.cardId)})
//                maximum!.value.forEach({answers.append($0.answer)})
//
//                let firstMatch = MatchRecordModel(id: UUID().uuidString, userProfileId: user.profileId, matchProfileId: maximum!.key, cardIds: cardsIds, answers: answers, isNew: true)
//
//                viewModel.successfullMatchSnapshots.append(firstMatch)
//            }
//
//            if maximum2 != nil {
//                var cardsIds2: [String] = []
//                var answers2: [String] = []
//                maximum2!.value.forEach({cardsIds2.append($0.cardId)})
//                maximum2!.value.forEach({answers2.append($0.answer)})
//
//                let secondMatch = MatchRecordModel(id: UUID().uuidString, userProfileId: user.profileId, matchProfileId: maximum2!.key, cardIds: cardsIds2, answers: answers2, isNew: true)
//
//                viewModel.successfullMatchSnapshots.append(secondMatch)
//            }
//
//            if maximum3 != nil {
//                var cardsIds3: [String] = []
//                var answers3: [String] = []
//                maximum3!.value.forEach({cardsIds3.append($0.cardId)})
//                maximum3!.value.forEach({answers3.append($0.answer)})
//
//                let thirdMatch = MatchRecordModel(id: UUID().uuidString, userProfileId: user.profileId, matchProfileId: maximum3!.key, cardIds: cardsIds3, answers: answers3, isNew: true)
//
//                viewModel.successfullMatchSnapshots.append(thirdMatch)
//            }
//        }
//        completed(viewModel.successfullMatchSnapshots)
//    }
//}


struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView(updateData: .constant(true), gotSwipedRecords: .constant(true), viewModel: LiveViewModel())
    }
}
