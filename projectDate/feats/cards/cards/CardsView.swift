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

    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(Array(self.cards.enumerated()), id: \.element) { index, card in
                    if index > self.cards.count - 4 {
                        CardView(card: card,index: index, onRemove: {
                            removedUser in
                            self.cards.removeAll { $0.id == removedUser.id }
                        }, updateData: $updateData)
                        .animation(.spring())
                        .frame(width:
                                self.cards.cardWidth(in: geometry,
                                                     cardId: index), height: 700)
                        .offset(x: 0,
                                y: self.cards.cardOffset(
                                    cardId: index))
                    }
                }.onChange(of: updateData) { newValue in
                    getAllCards(isUpdating: true)
                }
            }.onAppear{
                getAllCards(isUpdating: false)
            }
        }.padding()
    }
    
    public func getAllCards(isUpdating: Bool){
        var query: Query!
        
        if !isUpdating {
            query = db.collection("cards").limit(to: 3)
        } else {
            if (self.lastDoc != nil) {
                query = db.collection("cards").start(afterDocument: self.lastDoc).limit(to: 3)
            }
        }
        
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    do{
                        if !data.isEmpty{
                            let card = CardModel(id: document.documentID, question: data["question"] as? String ?? "", choices: data["choices"] as? [String] ?? [""], categoryType: data["categoryType"] as? String ?? "", profileType: data["profileType"] as? String ?? "")
                            
                            self.cards.append(card)
                        }
                    } catch {
                        print("Error!")
                    }
                }
                self.lastDoc = querySnapshot!.documents.last
            }
        }
    }
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView(updateData: .constant(false))
    }
}
