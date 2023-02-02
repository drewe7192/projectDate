//
//  CreateCardView.swift
//  projectDate
//
//  Created by DotZ3R0 on 2/1/23.
//

import SwiftUI

struct CreateCardView: View {
    @State private var question: String = ""
    @State private var answerA: String = ""
    @State private var answerB: String = ""
    @State private var answerC: String = ""
    @State private var showFriendDisplay: Bool = false
    
    @StateObject private var viewModel = LocalHomeViewModel()
    
    

    var body: some View {
        NavigationView{
            GeometryReader{ geoReader in
                ZStack{
                    Color(.systemTeal)
                        .ignoresSafeArea()
                  
                    Text("Logo")
                        .font(.system(size: 50))
                        .position(x: geoReader.frame(in: .local).midX , y: geoReader.size.height * 0.03)
                    
                    ForEach(viewModel.mockCards) { card in
                        if Int(card.id) ?? 0 > viewModel.mockCards.count - 4 {
                            CCardView(card: card, onRemove: {
                                removedUser in
                                viewModel.mockCards.removeAll { $0.id == removedUser.id }
                            })
                            .animation(.spring())
                            .frame(width:
                                    viewModel.mockCards.cardWidth(in: geoReader,
                                                                  userId:  Int(card.id) ?? 0), height: 700)
                            .offset(x: 0,
                                    y: viewModel.mockCards.cardOffset(
                                        userId: Int(card.id) ?? 0))
                        }

                    }
                    
                    HStack{
                        Button(action: {
                            createCard()
                        }) {
                            Text("Create")
                                .font(.system(size: 30))
                                .frame(width: 200, height: 100)
                                .foregroundColor(.white)
                                .background(.pink)
                                .cornerRadius(20)
                                .shadow(radius: 5, x: 6, y: 4)
                            
                            
                        }
                        
                        Button(action: {
                            createCard()
                        }) {
                            Text("Cancel")
                                .font(.system(size: 30))
                                .frame(width: 200, height: 100)
                                .foregroundColor(.white)
                                .background(.pink)
                                .cornerRadius(20)
                                .shadow(radius: 5, x: 6, y: 4)
                            
                        }
                    }
                    .position(x: geoReader.frame(in: .local).midX , y: geoReader.size.height * 0.85)
                    
                }
                .position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY )
                
            }
        }
    }
    
    private func createCard(){
        print("fdsfds");
    }
    
    
}

struct CCardView: View {
    @ObservedObject private var viewModel = EventViewModel()
    @State private var selectedColor = ""
    @State private var question: String = ""
    @State private var answerA: String = ""
    @State private var answerB: String = ""
    @State private var answerC: String = ""
    @State private var showFriendDisplay: Bool = false
    
    
    @State
    private var translation: CGSize = .zero
    private var card: CardModel
    private var onRemove: (_ card: CardModel) -> Void
    private var threshold: CGFloat = 0.5
    
    init(card: CardModel, onRemove: @escaping (_ card: CardModel)
         -> Void) {
        self.card = card
        self.onRemove = onRemove
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 20) {
                ZStack{
                    Rectangle()
                        .foregroundColor(.pink)
                        .cornerRadius(40)
                        .frame(width: geometry.size.width - 40,
                               height: geometry.size.height * 0.75)
                  
                    VStack{
                        
                        if(Int(card.id) == 5){
                            Text("Question:")
                                .bold()
                                .font(.system(size: 40))

                            HStack{
                                
                                Text("\(showFriendDisplay ? "Friend" : "Dater")")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                    .position(x: geometry.frame(in: .local).midX * 0.5 , y: geometry.size.height * 0.05)
                         
                                
                                Toggle(isOn: $showFriendDisplay, label: {
                                    
                                })
                                .toggleStyle(SwitchToggleStyle(tint: .white))
                                .position(x: geometry.frame(in: .local).midX * 0.1 , y: geometry.size.height * 0.05)
                            }
                            
                            TextEditor(text: $question)
                                .frame(width: 370, height: 200)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .opacity(0.5)
                                .textInputAutocapitalization(.never)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
                                )
                                .padding(.bottom,40)
                            
                
                        }
                        
                        
                        if(Int(card.id) == 4){
                            Text("Answers")
                                .bold()
                                .font(.system(size: 40))
                            ZStack{
                                // using 2 text fields to get the proper effect I want:
                                // a faded background inside textField but text is still bold
                                //and visible
                                TextField("", text: $answerA)
                                    .foregroundColor(.black)
                                    .frame(width: 340, height: 25)
                                    .padding()
                                    .background(.white)
                                    .opacity(0.5)
                                    .cornerRadius(10)
                                    .textInputAutocapitalization(.never)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 1)
                                    )
                                
                                
                                TextField("Answer A", text: $answerA)
                                    .foregroundColor(.black.opacity(0.2))
                                    .frame(width: 340, height: 25)
                                    .padding()
                                    .cornerRadius(10)
                                    .textInputAutocapitalization(.never)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
                                    )
                                    .padding(.bottom,3)
                            }
                            
                            ZStack{
                                // using 2 text fields to get the proper effect I want:
                                // a faded background inside textField but text is still bold
                                //and visible
                                TextField("", text: $answerB)
                                    .foregroundColor(.black)
                                    .frame(width: 340, height: 25)
                                    .padding()
                                    .background(.white)
                                    .opacity(0.5)
                                    .cornerRadius(10)
                                    .textInputAutocapitalization(.never)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 1)
                                    )
                                
                                
                                TextField("Answer B", text: $answerB)
                                    .foregroundColor(.black.opacity(0.2))
                                    .frame(width: 340, height: 25)
                                    .padding()
                                    .cornerRadius(10)
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
                                    .frame(width: 340, height: 25)
                                    .padding()
                                    .background(.white)
                                    .opacity(0.5)
                                    .cornerRadius(10)
                                    .textInputAutocapitalization(.never)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 1)
                                    )
                                
                                
                                TextField("Answer C", text: $answerC)
                                    .foregroundColor(.black.opacity(0.2))
                                    .frame(width: 340, height: 25)
                                    .padding()
                                    .cornerRadius(10)
                                    .textInputAutocapitalization(.never)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
                                    )
                            }
                        }
                        
                        if(Int(card.id) == 3){
                            Text("Create New Card?")
                                .bold()
                                .font(.system(size: 40))
                        }
                  
                    }
                    .frame(height: 400)
                    
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(40)
            .shadow(radius: 5)
            .animation(.spring())
            .offset(x: translation.width, y: 0)
            .rotationEffect(.degrees(
                Double(self.translation.width /
                       geometry.size.width)
                * 20), anchor: .bottom)
            .gesture(
                DragGesture()
                    .onChanged {
                        translation = $0.translation
                    }.onEnded {
                        if $0.percentage(in: geometry) > threshold {
                            onRemove(self.card)
                        } else {
                            translation = .zero
                        }
                    }
            )
        }
    }
    

    
  
}

struct CreateCardView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCardView()
    }
}
