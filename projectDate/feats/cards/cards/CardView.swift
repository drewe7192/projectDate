//
//  CardView.swift
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

struct CardView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedChoice = "Your Match's answer"
    @Binding var updateData: Bool
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let userProfile: ProfileModel
    
    @State
    private var translation: CGSize = .zero
    private var card: CardModel
    private var index: Int
    private var onRemove: (_ card: CardModel) -> Void
    private var threshold: CGFloat = 0.1
    
    enum LikeDislike: Int {
        case like, dislike, none
    }
    @State var swipeStatus: LikeDislike = .none
    
    init(card: CardModel, index: Int, onRemove: @escaping (_ card: CardModel)
         -> Void, updateData: Binding<Bool>, userProfile: ProfileModel) {
        self.card = card
        self.index = index
        self.onRemove = onRemove
        self._updateData = updateData
        self.userProfile = userProfile
    }
    
    var body: some View {
        GeometryReader { geoReader in
            VStack{
                ZStack{
                    Rectangle()
                        .foregroundColor(colorSwitch())
                        .cornerRadius(40)
                        .frame(width: geoReader.size.width * 0.9,
                               height: geoReader.size.height * 0.65)
                    VStack{
                        Text("How would your perfect match answer this question:")
                            .bold()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .font(.custom("Superclarendon", size: geoReader.size.height * 0.025))
                    }
                    .padding(.bottom,geoReader.size.height * 0.45)
                
                    
                    VStack{
                        Text("\(card.question)")
                            .font(.custom("Superclarendon", size: 25))
                            .foregroundColor(Color.white)
                        
                        Menu {
                            Picker(selection: $selectedChoice) {
                                ForEach(card.choices, id: \.self) { choice in
                                    Text("\(choice)")
                                        .tag(choice)
                                        .font(.system(size: 20))
                                }
                            } label: {}
                        } label: {
                            Text("\(selectedChoice)")
                                .font(.system(size: 20))
                        }
                        .accentColor(.white)
                    }
                    
                    ZStack{
                        Text("")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 30))
                            .frame(width: 60, height: 20)
                            .background(.black)
                            .cornerRadius(10)
                        
                        Text("Values")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 15))
                    }
                    .padding(.leading,300)
                    .padding(.top,geoReader.size.height * 0.6)
                }
           
                   
            }
           .padding()
           .background(colorSwitch())
            .cornerRadius(40)
            .shadow(radius: 5)
            .animation(.spring())
            .offset(x: translation.width, y: 0)
            .rotationEffect(.degrees(
                Double(self.translation.width /
                       geoReader.size.width)
                * 20), anchor: .bottom)
            .gesture(
                DragGesture()
                    .onChanged {
                        //translation changes as you drag card;
                        //if card gets dragged a certain distance, set it to like/dislike
                        translation = $0.translation
                        if $0.percentage(in: geoReader) >= threshold && translation.width < -110 {
                            self.swipeStatus = .dislike
                        } else if $0.percentage(in: geoReader) >= threshold && translation.width > 110 {
                            self.swipeStatus = .like
                        } else {
                            self.swipeStatus = .none
                        }
                    }.onEnded {_ in
                        // cant swipe right/like if question hasnt been answered
                        if (self.swipeStatus == .like) && (selectedChoice != "Your Match's answer") {
                            onRemove(self.card)
                            
                            // after each swipe save the card data and update the profiler section
                            saveSwipedRecords(card: self.card, answer: selectedChoice){ (success) in
                                if success{
                                    //last card in set is always index 0
                                    if(index == 0){
                                        // fires off the ".onChange" in the HomeView and CardsView
                                        updateData.toggle()
                                    }
                                    self.selectedChoice = "Your Match's answer"
                                }
                            }
                        } else if (self.swipeStatus == .dislike) {
                            onRemove(self.card)
                            
                            saveSwipedRecords(card: self.card, answer: "") { (success) in
                                if success{
                                    //last card in set is always index 0
                                    if(index == 0){
                                        // fires off the ".onChange" in the HomeView and CardsView
                                        updateData.toggle()
                                    }
                                    self.selectedChoice = "Your Match's answer"
                                }
                            }
                        }
                        translation = .zero
                    }
            )
        }
    }
    
    public func saveSwipedRecords(card: CardModel, answer: String, completed: @escaping (_ success: Bool) -> Void){
        let id = UUID().uuidString
        let docData: [String: Any] = [
            "id": id,
            "cardId": card.id,
            "answer": cardChoices(choices: card.choices, answer: answer),
            "swipedDate": Timestamp(date: Date()),
            "profileId": userProfile.id
        ]
        
        let docRef = db.collection("swipedRecords").document(id)
        
        docRef.setData(docData) {error in
            if let error = error {
                print("Error writing document to swipedRecords: \(error)")
                completed(false)
            }else {
                print("Document successfully written to swipedRecords!")
                completed(true)
            }
        }
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
    private func colorSwitch() -> Color{
        
        var foo: Color = Color.mainGrey
        switch card.categoryType {
        case "values":
            foo = Color.iceBreakrrrPink
        case "littleThings":
            foo = Color.iceBreakrrrBlue
        case "personality":
            foo = Color.mainGrey
        default:
            break
            
        }
        return foo
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: MockService.cardsSampleData.first!,index: 19, onRemove: {_ in}, updateData: .constant(true), userProfile: ProfileModel(id: "", fullName: "", location: "", gender: ""))
    }
}
