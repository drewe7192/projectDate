//
//  testView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import SwiftUI

struct SwipeCardsView: View {
    @StateObject private var viewModel = LocalHomeViewModel()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(Array(viewModel.swipeCards.enumerated()), id: \.element) { index, card in
                    if index > viewModel.swipeCards.count - 4 {
                        SwipeCardView(card: card, onRemove: {
                            removedUser in
                            viewModel.swipeCards.removeAll { $0.id == removedUser.id }
                        })
                        .animation(.spring())
                        .frame(width:
                                viewModel.swipeCards.cardWidth(in: geometry,
                                                cardId: index), height: 700)
                        .offset(x: 0,
                                y: viewModel.swipeCards.cardOffset(
                                    cardId: index))
                    }
                }
            }
        }.padding()
    }
}

struct SwipeCardsView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeCardsView()
    }
}
