//
//  QuestionsModel.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 7/26/25.
//

import Foundation
import Firebase

struct QuestionsModel {
    var questions: [QuestionModel]
    var lastDoc: QueryDocumentSnapshot?
}

var emptyQuestionsModel = QuestionsModel(questions: [], lastDoc: nil)
