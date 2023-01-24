//
//  LocalHomeViewModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import Foundation
import FirebaseFirestore

class LocalHomeViewModel: ObservableObject {
    //    @Published var swipeCards: [CardModel] = MockService.cardObjectSampleData.cards
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

