//
//  VideoViewModel.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 3/29/25.
//

import Foundation

@MainActor
class VideoViewModel: ObservableObject {
    @Published var roomCode: String = ""
    @Published var questions: [QuestionModel] = []
    
    private let videoService = VideoService()
    
    public func getQuestions() async throws {
        let questions = try await videoService.getQuestions()
        if !questions.isEmpty {
            self.questions = questions
        }
    }
}
