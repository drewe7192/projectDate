//
//  QuestionModel.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 4/25/25.
//

import Foundation
import Firebase

struct QuestionModel: Identifiable, Equatable, Hashable {
    var id: String
    var body: String
    var choices: [ChoiceModel]
    var lastDoc: QueryDocumentSnapshot?
}

var emptyQuestionModel = QuestionModel(id: "", body: "", choices: [])

