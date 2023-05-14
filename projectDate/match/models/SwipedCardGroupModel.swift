//
//  SwipedCardGroupModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/9/23.
//

import Foundation

struct SwipedCardGroupModel: Identifiable {
    var id: String
    var profileId: String
    var cardIds: [String]
    var answers: [String]
    var gender: String
}
