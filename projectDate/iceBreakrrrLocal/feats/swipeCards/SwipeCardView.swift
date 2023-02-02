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


struct SwipeCardView: View {
    @ObservedObject private var viewModel = EventViewModel()
    @State private var selectedColor = ""
    
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
                               height: geometry.size.height * 0.45)
                    
                    VStack{
                        Text("\(card.question)")
                            .font(.custom("Superclarendon", size: 20))
                            .foregroundColor(.white)
                            .padding(10)
                       
                        VStack {
                            Picker("", selection: $selectedColor) {
                                ForEach(card.choices, id: \.self) { choice in
                                    Text("\(choice)")
                                }
                              
                            }
                        }
                    }
                    .frame(height: 375)
                }
                
                Divider()
                
//                Text("Upcoming Event")
//                NavigationLink(destination: EventInfoView()){
//                    Text("\(viewModel.events.first!.title)")
//                        .foregroundColor(.black)
//                        .font(.title2)
//                        .bold()
//                        .padding(7)
//                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.blue, lineWidth: 4))
//                }
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

extension DragGesture.Value {
    func percentage(in geometry: GeometryProxy) ->      CGFloat {
        abs(translation.width / geometry.size.width)
    }
}

struct SwipeCardView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeCardView(card: MockService.cardsSampleData.first!, onRemove: {_ in})
    }
}
