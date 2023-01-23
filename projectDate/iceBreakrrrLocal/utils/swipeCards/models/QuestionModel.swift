//
//  QuestionModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/21/23.
//

import Foundation


struct QuestionModel: Identifiable {
    let id: Int
    let question: String
    let choices: [String]
    let isEvent: Bool
}
