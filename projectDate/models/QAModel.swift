//
//  QAModel.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 6/24/25.
//

import Foundation
import UIKit

struct QAModel: Identifiable, Equatable, Hashable {
    var id: String
    var answer: AnswerModel
    var question: QuestionModel
    var profileImage: UIImage
}

var emptyQAModel = QAModel(id: "", answer: emptyAnswerModel, question: emptyQuestionModel, profileImage: UIImage())
