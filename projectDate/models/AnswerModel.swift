//
//  AnswerModel.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 5/4/25.
//

import Foundation

struct AnswerModel: Identifiable, Equatable, Codable, Hashable {
    var id: String
    var profileId: String
    var questionId: String
    var body: String
    var isActive: Bool
    var askerProfileId: String
}

var emptyAnswerModel = AnswerModel(id: "", profileId: "", questionId: "",  body: "", isActive: false, askerProfileId: "")
