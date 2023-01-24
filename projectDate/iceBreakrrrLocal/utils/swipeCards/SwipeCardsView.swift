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
                ForEach(viewModel.swipeCards) { question in
                    if question.id > viewModel.swipeCards.maxId - 4 {
                        SwipeCardView(card: question, onRemove: {
                            removedUser in
                            viewModel.swipeCards.removeAll { $0.id == removedUser.id }
                        })
                        .animation(.spring())
                        .frame(width:
                                viewModel.swipeCards.cardWidth(in: geometry,
                                                userId: question.id), height: 700)
                        .offset(x: 0,
                                y: viewModel.swipeCards.cardOffset(
                                    userId: question.id))
                    }
                }
            }
        }.padding()
    }
}

extension Array where Element == CardModel {
    var maxId: Int { map { $0.id }.max() ?? 0 }
    
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
