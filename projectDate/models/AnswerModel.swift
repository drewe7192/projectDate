//
//  AnswerModel.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 5/4/25.
//

import Foundation

struct AnswerModel: Identifiable, Equatable, Codable {
    var id: String
    var profileId: String
    var questionId: String
    var answer: String
}

var emptyAnswerModel = AnswerModel(id: "", profileId: "", questionId: "", answer: "")
