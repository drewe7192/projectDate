//
//  testModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import Foundation

struct CardsModel: Identifiable {
    var id = UUID().uuidString
    var cards: [CardModel]
}
