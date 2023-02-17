//
//  QuestionModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/21/23.
//

import Foundation

struct CardModel: Codable, Identifiable, Hashable {
    var id : String
    var question: String
    var choices: [String]
    var categoryType: String
    var profileType: String

}
