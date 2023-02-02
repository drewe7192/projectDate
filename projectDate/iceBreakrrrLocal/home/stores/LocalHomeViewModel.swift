//
//  LocalHomeViewModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import Foundation
import FirebaseFirestore

class LocalHomeViewModel: ObservableObject {
        @Published var mockCards: [CardModel] = MockService.cardObjectSampleData.cards
    @Published var swipeCards: [CardModel] = []
    
    private var db = Firestore.firestore()
    
    init(){
        getAllData()
    }
    
    func getAllData(){
        db.collection("cards").addSnapshotListener{ (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents
            else {
                print("No documents")
                return
            }
            
            self.swipeCards = documents.compactMap {document -> CardModel? in
                do {
//                                        let data =  document.data()
//                                        let question = data["question"] as? String ?? ""
//                                        let category = data["category"] as? String ?? ""
//                                        let choices = data["choices"] as? [String] ?? []
//                                        let profileType = data["profileType"] as? String ?? ""
//                                        let cardOrderId = data["cardOrderId"] as? Int ?? 0
//
//                                        return  CardModel(cardOrderId: cardOrderId, question: question, choices: choices, category: category, profileType: profileType)
                    return try document.data(as: CardModel.self)
                } catch {
                    print("Error decoding document into Message: \(error)")
                    return nil
                }
            }
        }
    }
    
    
    init(forPreview: Bool = false) {
        if forPreview {
            swipeCards = MockService.cardObjectSampleData.cards
        }
    }
}

