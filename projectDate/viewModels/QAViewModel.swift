//
//  QAViewModel.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 5/11/25.
//

import Foundation
import FirebaseFunctions

@MainActor
class QAViewModel: ObservableObject {
    @Published var questions: [QuestionModel] = []
    @Published var answer: AnswerModel = emptyAnswerModel
    @Published var quickChatQuestion: QuestionModel = emptyQuestionModel
    
    private let videoService = VideoService()
    let functions = Functions.functions()
    
    public func getQuestions() async throws {
        let questions = try await videoService.getQuestions()
        if !questions.isEmpty {
            self.questions = questions
        }
    }
    
    public func saveAnswer(profileId: String) async throws {
        do {
            let requestObject = AnswerModel(id: UUID().uuidString, profileId: profileId, questionId: quickChatQuestion.id, body: answer.body)
            
            _ = try await videoService.saveAnswer(answer: requestObject)
        } catch let error {
            print("answer failed to save \(error)")
        }
    }
    
    func sendAnswerNotification(fcmToken: FCMTokenModel, role: RoleType, answer: String) async throws -> String {
        do {
            /// Used for testing
            //functions.useEmulator(withHost: "localhost", port: 5001)
            var result = ""
            let payload = [
                "fcmToken": fcmToken.token,
                "answer": answer,
            ]
            
            if role == RoleType.host {
                result = try await functions.httpsCallable("sendHostAnswerNotification").call(payload)
            } else {
                result = try await functions.httpsCallable("sendGuestAnswerNotification").call(payload)
            }
            return result
        }
    }
}
