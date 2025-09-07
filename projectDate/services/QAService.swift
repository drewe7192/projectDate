//
//  QAService.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 6/23/25.
//

import Foundation
import Firebase

class QAService {
    private let answerRepo = AnswerRepository()
    private let questionRepo = QuestionRepository()
    
    public func getQuestion(questionId: String) async throws -> QuestionModel {
        let response = try await questionRepo.Get(questionId: questionId)
        return response
    }
    
    public func getQuestions(lastDocumentSnapshot: QueryDocumentSnapshot?) async throws -> QuestionsModel {
        let response = try await questionRepo.Get(lastDocumentSnapshot: lastDocumentSnapshot)
        return response
    }
    
    func getRecentAnswers(profileId: String) async throws -> [AnswerModel]  {
        let response = try await answerRepo.GetRecent(profileId: profileId)
            return response
    }
    
    public func saveAnswer(answer: AnswerModel) async throws {
        _ = try await answerRepo.Save(answer: answer)
    }
    
}
