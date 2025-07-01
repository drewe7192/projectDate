//
//  QAService.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 6/23/25.
//

import Foundation

class QAService {
    private let answerRepo = AnswerRepository()
    private let questionRepo = QuestionRepository()
    
    func getRecentAnswers(profileId: String) async throws -> [AnswerModel]  {
        let response = try await answerRepo.GetRecent(profileId: profileId)
            return response
    }
    
    public func getQuestion(questionId: String) async throws -> QuestionModel {
        let response = try await questionRepo.Get(questionId: questionId)
        return response
    }
}
