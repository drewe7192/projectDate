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
    @ObservedObject var viewModel = HomeViewModel()
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
                    if index > self.cards.count - 4 {
                        CardView(
                            card: card,
                            index: index,
                            onRemove: {
                            removedUser in
                            self.cards.removeAll { $0.id == removedUser.id }
                        },
                        updateData: $updateData,
                        userProfile: self.userProfile)
                        .animation(.spring())
                        .frame(width:
                                self.cards.cardWidth(in: geometry,
                                                     cardId: index), height: geometry.size.height *  1.4)
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
           // .padding(3)
        }
        .padding(.leading,6)
        .padding(.trailing,6)
    }
    
    public func getAllCards(isUpdating: Bool){
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
                    
                    do{
                        if !data.isEmpty{
                            let card = CardModel(id: data["id"] as? String ?? "", question: data["question"] as? String ?? "", choices: data["choices"] as? [String] ?? [""], categoryType: data["categoryType"] as? String ?? "", profileType: data["profileType"] as? String ?? "")
                            
                            self.cards.append(card)
                        }
                    } catch {
                        print("Error!")
                    }
                }
                //important to get the next n cards from the db
                self.lastDoc = querySnapshot!.documents.last
            }
        }
    }
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView(updateData: .constant(false), userProfile: ProfileModel(id: "", fullName: "", location: "", gender: ""))
    }
}
