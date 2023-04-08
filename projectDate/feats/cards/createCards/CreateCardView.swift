//
//  CreateCardView.swift
//  projectDate
//
//  Created by DotZ3R0 on 2/1/23.
//

import SwiftUI

struct Categories: Identifiable {
    let id: Int
    let category: String
}
struct CreateCardView: View {
    @State private var selectedColor = ""
    
    @State private var showFriendDisplay: Bool = false
    @State var isLoading: Bool = false
    @State var translation: CGSize = .zero
    @State var card: CardModel
    @State var onRemove: (_ card: CardModel) -> Void
    @State var selectedCategoryState: String = ""
    
    @ObservedObject private var viewModel = EventViewModel()
    @Binding var swipeStatus: CreateCardsView.LikeDislike
    @Binding var question: String
    @Binding var answerA: String
    @Binding var answerB: String
    @Binding var answerC: String
    @Binding var categoryType: String
    @Binding var profileType: String
    
    var threshold: CGFloat = 0.1
    
    var body: some View {
        GeometryReader { geoReader in
                VStack(alignment: .leading, spacing: 20) {
                    ZStack{
                        Rectangle()
                            .foregroundColor(.mainGrey)
                            .cornerRadius(geoReader.size.width * 0.1)
                            .frame(width: geoReader.size.width * 0.9,
                                   height: geoReader.size.height * 0.75)
                        
                        cardViews(for: geoReader)
                    }
                }
                .padding(geoReader.size.width * 0.05)
                .background(Color.iceBreakrrrBlue)
                .cornerRadius(geoReader.size.width * 0.1)
                .shadow(radius: geoReader.size.width * 0.05)
                .animation(.spring())
                .offset(x: translation.width, y: 0)
                .rotationEffect(.degrees(
                    Double(self.translation.width /
                           geoReader.size.width)
                    * 20), anchor: .bottom)
                .gesture(
                    DragGesture()
                        .onChanged {
                            translation = $0.translation
                            
                            //duplicate code
                            // if card gets dragged to certain point on screen, deem it as like or dislike
                            if $0.percentage(in: geoReader) >= threshold && translation.width < -110 {
                                swipeStatus = .dislike
                            } else if $0.percentage(in: geoReader) >= threshold && translation.width > 110 {
                                swipeStatus = .like
                            } else {
                                swipeStatus = .none
                            }
                        }.onEnded {
                            
                            translation = $0.translation
                            
                            if swipeStatus == .dislike {
                                if (Int(card.id) == 3 && !question.isEmpty){
                                    question = ""
                                } else if (Int(card.id) == 2 && !answerA.isEmpty && !answerB.isEmpty && !answerC.isEmpty){
                                    answerA = ""
                                    answerB = ""
                                    answerC = ""
                                } else  if (Int(card.id) == 1 && !categoryType.isEmpty){
                                    categoryType = ""
                                }else if (Int(card.id) == 0){
                                    onRemove(self.card)
                                }
                                translation = .zero
                            } else if swipeStatus == .like {
                                if (Int(card.id) == 3 && !question.isEmpty){
                                    onRemove(self.card)
                                } else if (Int(card.id) == 2 && !answerA.isEmpty && !answerB.isEmpty && !answerC.isEmpty){
                                    onRemove(self.card)
                                }else  if (Int(card.id) == 1 && !categoryType.isEmpty){
                                    onRemove(self.card)
                                }
                                else if (Int(card.id) == 0){
                                    onRemove(self.card)
                                }
                            }
                            translation = .zero
                        }
                )
            .position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY )
        }
    }
    
    private func cardViews(for geoReader: GeometryProxy) -> some View {
        VStack{
            if(Int(card.id) == 3){
                Text("Question:")
                    .foregroundColor(.white)
                    .bold()
                    .font(.system(size: geoReader.size.height * 0.05))
                
                //FriendCard toggle feature for future versions
                //                HStack{
                //                    Text("\(showFriendDisplay ? "Friend" : "Dater")")
                //                        .font(.system(size: 40))
                //                        .foregroundColor(.white)
                //                        .position(x: geoReader.frame(in: .local).midX * 0.5 , y: geoReader.size.height * 0.05)
                //
                //
                //                    Toggle(isOn: $showFriendDisplay, label: {
                //
                //                    })
                //                    .toggleStyle(SwitchToggleStyle(tint: .white))
                //                    .position(x: geoReader.frame(in: .local).midX * 0.1 , y: geoReader.size.height * 0.05)
                //                }
                
                //                TextEditor(text: $question)
                //                    .frame(width: geoReader.size.width * 0.8, height: geoReader.size.height * 0.2)
                //                    .foregroundColor(.white)
                //                    .cornerRadius(geoReader.size.width * 0.03)
                //                    .opacity(0.5)
                //                    .textInputAutocapitalization(.never)
                //                    .overlay(
                //                        RoundedRectangle(cornerRadius: geoReader.size.width * 0.03).stroke(.white, lineWidth: 2)
                //                    )
                //                    .padding(.bottom,geoReader.size.width * 0.2)
                
                VStack {
                    TextEditor(text: $question)
                        .frame(width: geoReader.size.width * 0.8, height: geoReader.size.height * 0.2)
                        .foregroundColor(.white)
                        .cornerRadius(geoReader.size.width * 0.03)
                        .opacity(0.5)
                        .textInputAutocapitalization(.never)
                        .overlay(
                            RoundedRectangle(cornerRadius: geoReader.size.width * 0.03).stroke(.white, lineWidth: 2)
                        )
                        .padding(.bottom,geoReader.size.width * 0.02)
                    Button {
                        dismissKeyboard() // 1
                    } label : {
                        Text("Dismiss Keyboard")
                            .frame(width: 200, height: 30)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(20)
                            .shadow(radius: 15, x: 12, y: 10)
                    }
                    
                }
            }
            
            if(Int(card.id) == 2){
                Text("Top answers you're looking for?")
                    .foregroundColor(Color.white)
                    .bold()
                    .font(.system(size: geoReader.size.height * 0.05))
                ZStack{
                    // using 2 text fields to get the proper effect I want:
                    // a faded background inside textField but text is still bold
                    //and visible
                    TextField("", text: $answerA)
                        .foregroundColor(.black)
                        .frame(width: geoReader.size.width * 0.75, height: geoReader.size.height * 0.02)
                        .padding()
                        .background(.white)
                        .opacity(0.5)
                        .cornerRadius(geoReader.size.width * 0.03)
                        .textInputAutocapitalization(.never)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 1)
                        )
                    
                    
                    TextField("Answer A", text: $answerA)
                        .foregroundColor(.black.opacity(0.2))
                        .frame(width: geoReader.size.width * 0.75, height: geoReader.size.height * 0.02)
                        .padding()
                        .cornerRadius(geoReader.size.width * 0.03)
                        .textInputAutocapitalization(.never)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
                        )
                }
                
                ZStack{
                    // using 2 text fields to get the proper effect I want:
                    // a faded background inside textField but text is still bold
                    //and visible
                    TextField("", text: $answerB)
                        .foregroundColor(.black)
                        .frame(width: geoReader.size.width * 0.75, height: geoReader.size.height * 0.02)
                        .padding()
                        .background(.white)
                        .opacity(0.5)
                        .cornerRadius(geoReader.size.width * 0.03)
                        .textInputAutocapitalization(.never)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 1)
                        )
                    
                    
                    TextField("Answer B", text: $answerB)
                        .foregroundColor(.black.opacity(0.2))
                        .frame(width: geoReader.size.width * 0.75, height: geoReader.size.height * 0.02)
                        .padding()
                        .cornerRadius(geoReader.size.width * 0.03)
                        .textInputAutocapitalization(.never)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
                        )
                }
                
                ZStack{
                    // using 2 text fields to get the proper effect I want:
                    // a faded background inside textField but text is still bold
                    //and visible
                    TextField("", text: $answerC)
                        .foregroundColor(.black)
                        .frame(width: geoReader.size.width * 0.75, height: geoReader.size.height * 0.02)
                        .padding()
                        .background(.white)
                        .opacity(0.5)
                        .cornerRadius(geoReader.size.width * 0.03)
                        .textInputAutocapitalization(.never)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 1)
                        )
                    
                    TextField("Answer C", text: $answerC)
                        .foregroundColor(.black.opacity(0.2))
                        .frame(width: geoReader.size.width * 0.75, height: geoReader.size.height * 0.02)
                        .padding()
                        .cornerRadius(geoReader.size.width * 0.03)
                        .textInputAutocapitalization(.never)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
                        )
                }
            }
            
            if(Int(card.id) == 1){
                let contacts = [
                    //started with 1 instead of 0 becuase selectedCategory state default value is 0
                    Categories(id: 1, category: "Values"),
                    Categories(id: 2, category: "Little things"),
                    Categories(id: 3, category: "Personality"),
                ]
                
                VStack(spacing: 20){
                    Text("Choose Category Type")
                        .foregroundColor(Color.white)
                        .bold()
                        .font(.system(size: geoReader.size.height * 0.04))
                        .padding(.bottom)
                    
                    ForEach(contacts) {contact in
                        Button(action: {
                            if(selectedCategoryState == contact.category){
                                    selectedCategoryState = ""
                                categoryType = ""
                            } else{
                                selectedCategoryState = contact.category
                                categoryType = contact.category
                            }


                        }) {
                            Text("\(contact.category)")
                                .bold()
                                .foregroundColor(.white)
                        }
                            .frame(width: 300,height: 50)
                            .background(categoryType == contact.category ? Color.iceBreakrrrPink : Color.mainGrey)
                            .foregroundColor(.white)
                            .cornerRadius(22)
                            .shadow(radius: 5, x: 7, y: 10)
                    }
                }
            }
            
            if(Int(card.id) == 0){
                Text("Swipe right to create new Card!")
                    .foregroundColor(Color.white)
                    .bold()
                    .font(.system(size: geoReader.size.height * 0.05))
            }
        }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true)
    }
}

struct CreateCardView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCardView(card: MockService.cardsSampleData.first!,onRemove: {_ in}, swipeStatus: CreateCardsView(showCardCreatedAlert: .constant(true),userProfile: ProfileModel(id: "fj8fsnfuh439", fullName: "dotZe30", location: "Tampa,Fl", gender: "Male", matchDay: "Mondays", messageThreadIds: [])).$swipeStatus, question: CreateCardsView(showCardCreatedAlert: .constant(true),userProfile: ProfileModel(id: "fj8fsnfuh439", fullName: "dotZe30", location: "Tampa,Fl", gender: "Male", matchDay: "Mondays", messageThreadIds: [])).$question , answerA: CreateCardsView(showCardCreatedAlert: .constant(true),userProfile: ProfileModel(id: "fj8fsnfuh439", fullName: "dotZe30", location: "Tampa,Fl", gender: "Male", matchDay: "Mondays", messageThreadIds: [])).$answerA, answerB: CreateCardsView(showCardCreatedAlert: .constant(true),userProfile: ProfileModel(id: "fj8fsnfuh439", fullName: "dotZe30", location: "Tampa,Fl", gender: "Male", matchDay: "Mondays", messageThreadIds: [])).$answerB, answerC: CreateCardsView(showCardCreatedAlert: .constant(true),userProfile: ProfileModel(id: "fj8fsnfuh439", fullName: "dotZe30", location: "Tampa,Fl", gender: "Male", matchDay: "Mondays", messageThreadIds: [])).$answerC , categoryType: CreateCardsView(showCardCreatedAlert: .constant(true),userProfile: ProfileModel(id: "fj8fsnfuh439", fullName: "dotZe30", location: "Tampa,Fl", gender: "Male", matchDay: "Mondays", messageThreadIds: [])).$categoryType, profileType: CreateCardsView(showCardCreatedAlert: .constant(true),userProfile: ProfileModel(id: "fj8fsnfuh439", fullName: "dotZe30", location: "Tampa,Fl", gender: "Male", matchDay: "Mondays", messageThreadIds: [])).$profileType )
    }
}
