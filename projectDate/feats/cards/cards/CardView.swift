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
    @State private var selectedChoice = "Your Match's Answer"
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
        case like, dislike, noAnswer,none
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
                        .foregroundColor(Color.mainGrey)
                        .cornerRadius(40)
                        .frame(width: geoReader.size.width * 0.9,
                               height: geoReader.size.height * 0.65)
                    
                    title(for: geoReader)
                    question(for: geoReader)
                    categoryDisplay(for: geoReader)
                    
                    if self.translation.width < -10 {
                        Text("ANSWER LATER")
                            .font(.title3)
                            .bold()
                            .padding()
                            .cornerRadius(10)
                            .foregroundColor(Color.red)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.red, lineWidth: 5.0)
                            )
                            .padding(.leading, 205)
                            .rotationEffect(Angle.degrees(45))
                    }
                    
                    if self.translation.width > 10 {
                        Text("SUBMIT ANSWER")
                            .font(.title3)
                            .bold()
                            .padding()
                            .cornerRadius(10)
                            .foregroundColor(Color.green)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.green, lineWidth: 5.0)
                            )
                            .padding(.trailing, 245)
                            .rotationEffect(Angle.degrees(45))
                    }
                    
                    if self.swipeStatus == .noAnswer {
                        Text("Please answer question")
                            .font(.title3)
                            .bold()
                            .frame(width: 100, height: 100)
                            .padding()
                            .cornerRadius(10)
                            .foregroundColor(Color.orange)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.orange, lineWidth: 5.0)
                            )
                            .padding(.trailing, 145)
                            .rotationEffect(Angle.degrees(45))
                        
                    }
                }
            }
            .padding()
            .background(Color.mainGrey)
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
                        translation = $0.translation
                        
                        //if card gets dragged a certain distance, set it to like/dislike
                        if $0.percentage(in: geoReader) >= threshold && translation.width < -110 {
                            self.swipeStatus = .dislike
                        } else if $0.percentage(in: geoReader) >= threshold && translation.width > 110 {
                            self.swipeStatus = .like
                        } else {
                            self.swipeStatus = .none
                        }
                    }
                    .onEnded {_ in
                        if (selectedChoice == "Your Match's Answer") && (self.swipeStatus == .like) {
                            self.swipeStatus = .noAnswer
                        }
                        // cant swipe right(.like) if question hasnt been answered
                        else if (self.swipeStatus == .like) && (selectedChoice != "Your Match's Answer") {
                            onRemove(self.card)
                            
                            // after each swipe save the card data
                            saveSwipedRecords(card: self.card, answer: selectedChoice){ (success) in
                                if success{
                                    //last card in set is always index 0
                                    if(index == 0){
                                        // fires off the ".onChange" in the HomeView and CardsView
                                        updateData.toggle()
                                    }
                                    self.selectedChoice = "Your Match's Answer"
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
                                    self.selectedChoice = "Your Match's Answer"
                                }
                            }
                        }
                        translation = .zero
                    }
            )
        }
    }
    
    private func title(for geoReader: GeometryProxy) -> some View {
        VStack{
            Text("How would your perfect match answer this question:")
                .bold()
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .font(.custom("Superclarendon", size: geoReader.size.height * 0.030))
        }
        .padding(.bottom,geoReader.size.height * 0.40)
    }
    
    private func question(for geoReader: GeometryProxy) -> some View {
        VStack{
            Text("\(card.question)")
                .font(.custom("Superclarendon", size: 20))
                .foregroundColor(Color.white)
            
            Menu {
                Picker(selection: $selectedChoice) {
                    ForEach(card.choices, id: \.self) { choice in
                        Text("\(choice)")
                            .tag(choice)
                            .font(.system(size: 30))
                    }
                } label: {}
            } label: {
                Text("\(selectedChoice)")
                    .font(.system(size: 20))
                    .padding(.top)
            }
            .accentColor(.white)
        }
    }
    
    private func categoryDisplay(for geoReader: GeometryProxy) -> some View {
        ZStack{
            Text("")
                .bold()
                .frame(width: geoReader.size.width * 0.24, height: geoReader.size.height * 0.05)
                .background(colorSwitch())
                .cornerRadius(20)
            
            Text("\(card.categoryType)")
                .foregroundColor(Color.black)
                .bold()
                .font(.system(size: 16))
        }
        .padding(.top,geoReader.size.height * 0.55)
        .padding(.leading,geoReader.size.width * 0.6)
    }
    
    private func saveSwipedRecords(card: CardModel, answer: String, completed: @escaping (_ success: Bool) -> Void){
        let id = UUID().uuidString
        let docData: [String: Any] = [
            "id": id,
            "cardId": card.id,
            "answer": cardChoices(choices: card.choices, answer: answer),
            "swipedDate": Timestamp(date: Date()),
            "profileId": userProfile.id,
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
    
    //color cards based on categoryType
    private func colorSwitch() -> Color{
        var cardColor: Color = Color.mainGrey
        
        switch card.categoryType {
        case "values":
            cardColor = Color.iceBreakrrrPink
        case "little things":
            cardColor = Color.iceBreakrrrBlue
        case "personality":
            cardColor = Color.orange
        case "dealBreaker":
            cardColor = Color.red
        default:
            break
        }
        return cardColor
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: MockService.cardsSampleData.first!,index: 19, onRemove: {_ in}, updateData: .constant(true), userProfile: ProfileModel(id: "", fullName: "", location: "", gender: "", matchDay: "Tuesdays", messageThreadIds: [], speedDateIds: [], fcmTokens: [], preferredGender: "", currentRoomId: ""))
    }
}
