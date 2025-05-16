//
//  QAViewModel.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 5/11/25.
//

import Foundation

@MainActor
class QAViewModel: ObservableObject {
    @Published var questions: [QuestionModel] = []
    @Published var answer: AnswerModel = emptyAnswerModel
    
    private let videoService = VideoService()
    
    public func getQuestions() async throws {
        let questions = try await videoService.getQuestions()
        if !questions.isEmpty {
            self.questions = questions
        }
    }
    
    public func saveAnswer() async throws {
        do {
             _ = try await videoService.saveAnswer(answer: answer)
        } catch let error {
            print("answer failed to save \(error)")
        }
    }
}
