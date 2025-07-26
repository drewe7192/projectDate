//
//  QuestionRepository.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 4/26/25.
//

import Foundation
import Firebase
import SwiftUICore


class QuestionRepository {
    let db = Firestore.firestore()
    
    public func Get() async throws -> [QuestionModel] {
        var questions: [QuestionModel] = []
        let snapshot = try await db.collection("questions")
            .limit(to: 10)
            .getDocuments()
        
        snapshot.documents.forEach { documentSnapshot in
            let documentData = documentSnapshot.data()
            
            var question: QuestionModel = emptyQuestionModel
            question.id = documentData["id"] as! String
            question.body = documentData["body"] as! String
            
            var choices = documentData["choices"] as! [String]
            for choice in choices {
                question.choices.append(ChoiceModel(id: UUID().uuidString, text: choice))
            }
            questions.append(question)
        }
        return questions
    }
    
    public func Get(questionId: String) async throws -> QuestionModel {
        var question: QuestionModel = emptyQuestionModel
        let snapshot = try await db.collection("questions")
            .whereField("id", isEqualTo: questionId)
            .getDocuments()
        
        snapshot.documents.forEach { documentSnapshot in
            let documentData = documentSnapshot.data()
            
            question.id = documentData["id"] as! String
            question.body = documentData["body"] as! String
            
            var choices = documentData["choices"] as! [String]
            for choice in choices {
                question.choices.append(ChoiceModel(id: UUID().uuidString, text: choice))
            }
        }
        return question
    }
}
