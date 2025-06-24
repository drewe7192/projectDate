//
//  QAService.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 6/23/25.
//

import Foundation

class QAService {
    private let answerRepo = AnswerRepository()
    
    func getRecentAnswers() async throws -> [AnswerModel]  {
            let response = try await answerRepo.GetRecent()
            return response
    }
}
