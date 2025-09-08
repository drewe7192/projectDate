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
    
    public func Get(lastDocumentSnapshot: QueryDocumentSnapshot?) async throws -> QuestionsModel {
        var snapshot: QuerySnapshot
        var questions: QuestionsModel = emptyQuestionsModel
        
        let query = db.collection("questions").order(by: "id")
        let initalQuery = query.limit(to: 10)
        var nextQuery = initalQuery
        if lastDocumentSnapshot != nil {
            nextQuery = query.start(afterDocument: lastDocumentSnapshot!).limit(to: 10)
        }
      
        /// get next batch of questions
        if lastDocumentSnapshot != nil {
            snapshot = try await nextQuery.getDocuments()
        } else {
            snapshot = try await initalQuery.getDocuments()
        }
        
        snapshot.documents.forEach { documentSnapshot in
            let documentData = documentSnapshot.data()
            
            var question: QuestionModel = emptyQuestionModel
            question.id = documentData["id"] as! String
            question.body = documentData["body"] as! String
            
            let choices = documentData["choices"] as! [String]
            for choice in choices {
                question.choices.append(ChoiceModel(id: UUID().uuidString, text: choice))
            }
            questions.questions.append(question)
        }
        
        /// set to avoid getting same questions
        if let lastDocument = snapshot.documents.last {
            questions.lastDoc = lastDocument
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
            
            let choices = documentData["choices"] as! [String]
            for choice in choices {
                question.choices.append(ChoiceModel(id: UUID().uuidString, text: choice))
            }
        }
        return question
    }
}
