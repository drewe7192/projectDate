//
//  CreateCardView.swift
//  projectDate
//
//  Created by DotZ3R0 on 2/1/23.
//

import SwiftUI

struct CreateCardView: View {
    @State private var selectedColor = ""
    @State private var question: String = ""
    @State private var answerA: String = ""
    @State private var answerB: String = ""
    @State private var answerC: String = ""
    @State private var showFriendDisplay: Bool = false
    @State var isLoading: Bool = false
    @State var translation: CGSize = .zero
    @State var card: CardModel
    @State var onRemove: (_ card: CardModel) -> Void
    
    @ObservedObject private var viewModel = EventViewModel()
    @Binding var swipeStatus: CreateCardsView.LikeDislike
    var threshold: CGFloat = 0.5
    
    var body: some View {
        GeometryReader { geoReader in
            VStack(alignment: .leading, spacing: 20) {
                ZStack{
                    Rectangle()
                        .foregroundColor(.pink)
                        .cornerRadius(40)
                        .frame(width: geoReader.size.width - 40,
                               height: geoReader.size.height * 0.75)
                    
                    cardViews(for: geoReader)
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
                       geoReader.size.width)
                * 20), anchor: .bottom)
            .gesture(
                DragGesture()
                    .onChanged {
                        translation = $0.translation
                        
                        //duplicate code
                        // if card gets dragged to certain point on screen, deem it as like or dislike
                        if $0.percentage(in: geoReader) >= threshold && translation.width < -195 {
                            swipeStatus = .like
                        } else if $0.percentage(in: geoReader) >= threshold && translation.width > 197 {
                            swipeStatus = .dislike
                        } else {
                            swipeStatus = .none
                        }
                    }.onEnded {
                        translation = $0.translation
                        
                        if swipeStatus == .dislike {
                            answerA = ""
                            answerB = ""
                            answerC = ""
                            question = ""
                            translation = .zero
                        } else if swipeStatus == .like{
                            onRemove(self.card)
                        }
                    }
            )
        }
    }
    
    private func cardViews(for geoReader: GeometryProxy) -> some View {
        VStack{
            if(Int(card.id) == 2){
                Text("Question:")
                    .bold()
                    .font(.system(size: 40))
                
                HStack{
                    Text("\(showFriendDisplay ? "Friend" : "Dater")")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .position(x: geoReader.frame(in: .local).midX * 0.5 , y: geoReader.size.height * 0.05)
                    
                    
                    Toggle(isOn: $showFriendDisplay, label: {
                        
                    })
                    .toggleStyle(SwitchToggleStyle(tint: .white))
                    .position(x: geoReader.frame(in: .local).midX * 0.1 , y: geoReader.size.height * 0.05)
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
            
            if(Int(card.id) == 1){
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
            
            if(Int(card.id) == 0){
                Text("Create New Card?")
                    .bold()
                    .font(.system(size: 40))
            }
        }
        .frame(height: 400)
    }
}

struct CreateCardView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCardView(card: MockService.cardsSampleData.first!,onRemove: {_ in}, swipeStatus: CreateCardsView().$swipeStatus)
    }
}
