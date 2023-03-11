//
//  SwipedCardGroupsModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/9/23.
//

import Foundation

struct SwipedCardGroupsModel: Identifiable {
    var id: String
    var userCardGroup: SwipedCardGroupModel
    var otherCardGroups: [SwipedCardGroupModel]
}
