//
//  VideoService.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 4/26/25.
//

import Foundation
import Firebase


class VideoService {
    private let questionRepo = QuestionRepository()
    private let answerRepo = AnswerRepository()
    
    public func getQuestions() async throws -> [QuestionModel] {
        let response = try await questionRepo.Get()
        return response
    }
    
    public func saveAnswer(answer: AnswerModel) async throws {
        _ = try await answerRepo.Save(answer: answer)
    }
}
