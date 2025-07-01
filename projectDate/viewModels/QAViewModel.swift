//
//  QAViewModel.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 5/11/25.
//

import Foundation
import Firebase
import FirebaseFunctions
import UIKit
import FirebaseStorage

@MainActor
class QAViewModel: ObservableObject {
    @Published var questions: [QuestionModel] = []
    @Published var answer: AnswerModel = emptyAnswerModel
    @Published var quickChatQuestion: QuestionModel = emptyQuestionModel
    @Published var recentAnswers: [AnswerModel] = []
    @Published var recentQAs: [QAModel] = []
    @Published var recentQAImages: [QADTOModel] = []
    
    private let videoService = VideoService()
    private let qaService = QAService()
    let functions = Functions.functions()
    let storage = Storage.storage()
    let db = Firestore.firestore()
    
    public func getQuestions() async throws {
        let questions = try await videoService.getQuestions()
        if !questions.isEmpty {
            self.questions = questions
        }
    }
    
    public func saveAnswer(profileId: String, askerProfileId: String) async throws {
        do {
            let requestObject = AnswerModel(id: UUID().uuidString, profileId: profileId, questionId: quickChatQuestion.id, body: answer.body, isActive: true, askerProfileId: askerProfileId)
            
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
    
    func getRecentAnswers(profileId: String) async throws {
        let recentAnswers = try await qaService.getRecentAnswers(profileId: profileId)
        
        if !recentAnswers.isEmpty {
            self.recentAnswers = recentAnswers
        }
    }
    
    func getRecentQA(profileId: String) async throws {
        try await getRecentAnswers(profileId: profileId)
        for recentAnswer in self.recentAnswers {
            let question = try await qaService.getQuestion(questionId: recentAnswer.questionId)
            
            getFileFromStorage(profileId: recentAnswer.profileId) {(data, error) in
                if let error = error {
                    print("Error getting file from storage: \(error)")
                } else if ((data?.isEmpty) != nil) {
                    let recentQA = QAModel(id: UUID().uuidString, answer: recentAnswer, question: question, profileImage: UIImage(data: data!) ?? UIImage())
                    
                    self.recentQAs.append(recentQA)
                }
            }
        }
    }
    
    func getFileFromStorage(profileId: String, completion: @escaping (Data?, Error?) -> Void){
        let ref = storage.reference().child("\(profileId)/images/image.jpg")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error getting file from storage: \(error)")
                completion(data, error)
            } else {
                if let image1 = UIImage(data: data!) {
                    // Process the image (e.g., store it in a variable)
                    self.recentQAImages.append(QADTOModel(profileId: profileId, profileImage: image1))
                }
                completion(data, error)
            }
        }
    }
    
    public func updateAnswers() async throws {
        for recentQA in self.recentQAs {
            let docRef = db.collection("answers").document(recentQA.answer.id)
            try await docRef.updateData([
                "isActive": false
            ])
        }
    }
}
