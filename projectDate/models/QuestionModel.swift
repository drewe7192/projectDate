//
//  QuestionModel.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 4/25/25.
//

import Foundation

struct QuestionModel: Identifiable, Equatable, Hashable {
    var id: String
    var body: String
    var answers: [String]
}

var emptyQuestionModel = QuestionModel(id: "", body: "", answers: [])

