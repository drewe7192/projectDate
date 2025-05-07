//
//  QuestionRepository.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 4/26/25.
//

import Foundation
import Firebase


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
            question.answers = documentData["answers"] as! [String]
            
            questions.append(question)
        }
        return questions
    }
}
