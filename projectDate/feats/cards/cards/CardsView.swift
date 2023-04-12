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
    @StateObject var viewModel = HomeViewModel()
    @State var cards: [CardModel] = []
    @State var lastDoc: DocumentSnapshot!
    
    @Binding var updateData: Bool
    let userProfile: ProfileModel
    
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
                            userProfile: self.userProfile
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
            }.onAppear{
                getAllCards(isUpdating: false)
            }
        }
        .padding(.leading,13)
        .padding(.trailing,6)
    }
    
    private func getAllCards(isUpdating: Bool){
        var query: Query!
        
        //pagination: get first n cards or get the next n cards
        if !isUpdating {
            query = db.collection("cards").limit(to: 10)
        } else {
            if (self.lastDoc != nil) {
                query = db.collection("cards").start(afterDocument: self.lastDoc).limit(to: 10)
            }
        }
        
        query.getDocuments() { (querySnapshot, err) in
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
    }
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView(updateData: .constant(false), userProfile: ProfileModel(id: "", fullName: "", location: "", gender: "", matchDay: "Wednesdays", messageThreadIds: []))
    }
}
