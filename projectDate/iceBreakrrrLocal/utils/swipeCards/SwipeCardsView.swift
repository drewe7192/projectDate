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
                    if index > viewModel.swipeCards.maxId(index: index) - 4 {
                        SwipeCardView(card: card, onRemove: {
                            removedUser in
                            viewModel.swipeCards.removeAll { $0.id == removedUser.id }
                        })
                        .animation(.spring())
                        .frame(width:
                                viewModel.swipeCards.cardWidth(in: geometry,
                                                userId: index), height: 700)
                        .offset(x: 0,
                                y: viewModel.swipeCards.cardOffset(
                                    userId: index))
                    }
                }
            }
        }.padding()
    }
}

extension Array where Element == CardModel {
    func maxId(index: Int) -> Int{
        var maxId: Int { map { _ in index }.max() ?? 0 }
        return maxId
    }
    
    
    func cardOffset(userId: Int) -> CGFloat {
        CGFloat(count - 1 - userId) * 8
    }
    
    func cardWidth(in geometry: GeometryProxy,
                   userId: Int) -> CGFloat {
        geometry.size.width - cardOffset(userId: userId)
    }
}

struct SwipeCardsView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeCardsView()
    }
}
