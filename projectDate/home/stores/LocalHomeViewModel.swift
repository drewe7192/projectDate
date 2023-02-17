//
//  LocalHomeViewModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

class LocalHomeViewModel: ObservableObject {
    @Published var createCards: [CardModel] = MockService.cardObjectSampleData.cards
    @Published var cards: [CardModel] = []
    @Published var cardsSwipedToday: [String] = []
    @Published var cardsFromSwipedIds: [CardModel] = []
    @Published var valuesCount: [String] = []
    @Published var qualitiesCount: [CardModel] = []
    @Published var commitmentCount: [String] = []
    
    private var db = Firestore.firestore()
    
    init(){
        getAllData()
        getCardsSwipedToday(){ (success) -> Void in
            if !success.isEmpty {
                self.getCardFromIds(cardIds: success)
            }
        }
    }
    
    private func getAllData(){
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
    }
    
    // change today to this week
    public func getCardsSwipedToday(completed: @escaping (_ success: [String]) -> Void) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let start = calendar.date(from: components)!
        let end = calendar.date(byAdding: .day, value: 1, to: start)!
        
        db.collection("swipedCards")
            .whereField("userId", isEqualTo: Auth.auth().currentUser?.uid)
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
                self.qualitiesCount = self.cardsFromSwipedIds
            }
    }
    
    public func saveSwipedCard(card: CardModel, answer: String){
        let docData: [String: Any] = [
            "cardId": card.id,
            "answer": cardChoices(choices: card.choices, answer: answer),
            "id": UUID().uuidString,
            "swipedDate": Timestamp(date: Date()),
            "userId": Auth.auth().currentUser?.uid
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
            "profileType": profileType
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
    
    init(forPreview: Bool = false) {
        if forPreview {
            cards = MockService.cardObjectSampleData.cards
        }
    }
}

