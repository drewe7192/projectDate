//
//  CardView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import SwiftUI
struct Contact: Identifiable {
    let id = UUID()
    let name: String
}


struct CardView: View {
    @ObservedObject private var viewModel = HomeViewModel()
    @State private var selectedChoice = "Your Matches answer"
    
    @State
    private var translation: CGSize = .zero
    private var card: CardModel
    private var onRemove: (_ card: CardModel) -> Void
    private var threshold: CGFloat = 0.1
    
    enum LikeDislike: Int {
        case like, dislike, none
    }
    @State var swipeStatus: LikeDislike = .none
    
    init(card: CardModel, onRemove: @escaping (_ card: CardModel)
         -> Void) {
        self.card = card
        self.onRemove = onRemove
    }
    
    var body: some View {
        GeometryReader { geoReader in
            VStack(alignment: .leading, spacing: 20) {
                ZStack{
                    Rectangle()
                        .foregroundColor(Color.iceBreakrrrBlue)
                        .cornerRadius(40)
                        .frame(width: geoReader.size.width * 0.9,
                               height: geoReader.size.height * 0.45)
                    
                    VStack{
                        Text("\(card.question)")
                            .font(.custom("Superclarendon", size: 20))
                            .foregroundColor(.white)
                            .padding(geoReader.size.width * 0.03)
                        
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
                    .frame(height: geoReader.size.height * 0.4)
                }
            }
            .padding(20)
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
                        translation = $0.translation
                        if $0.percentage(in: geoReader) >= threshold && translation.width < -110 {
                            self.swipeStatus = .dislike
                        } else if $0.percentage(in: geoReader) >= threshold && translation.width > 110 {
                            self.swipeStatus = .like
                        } else {
                            self.swipeStatus = .none
                        }
                    }.onEnded {_ in
                            if (self.swipeStatus == .like) && (selectedChoice != "Your Matches answer") {
                                onRemove(self.card)
                                
                                // after each swipe save the card data and update the profiler section
                                viewModel.saveSwipedCard(card: self.card, answer: selectedChoice)
                                 viewModel.getCardsSwipedToday()
                            } else if (self.swipeStatus == .dislike) {
                                onRemove(self.card)
                                
                                //save swiped card after each swipe
                                viewModel.saveSwipedCard(card: self.card, answer: "")
                            }
                                translation = .zero
                        }
            )
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: MockService.cardsSampleData.first!, onRemove: {_ in})
    }
}
