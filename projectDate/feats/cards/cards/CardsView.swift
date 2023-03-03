//
//  testView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import SwiftUI

struct CardsView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(Array(viewModel.cards.enumerated()), id: \.offset) { index, card in
                    if index > viewModel.cards.count - 4 {
                        CardView(card: card, onRemove: {
                            removedUser in
                            viewModel.cards.removeAll { $0.id == removedUser.id }
                        })
                        .animation(.spring())
                        .frame(width:
                                viewModel.cards.cardWidth(in: geometry,
                                                cardId: index), height: 700)
                        .offset(x: 0,
                                y: viewModel.cards.cardOffset(
                                    cardId: index))
                    }
                }
            }
        }.padding()
    }
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView()
    }
}
