//
//  AnswerRepository.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 5/11/25.
//

import Foundation
import Firebase


class AnswerRepository {
    let db = Firestore.firestore()
    
    public func Get() async throws -> [AnswerModel] {
        var answers: [AnswerModel] = []
        let snapshot = try await db.collection("answers")
            .limit(to: 10)
            .getDocuments()
        
        snapshot.documents.forEach { documentSnapshot in
            let documentData = documentSnapshot.data()
            
            var answer: AnswerModel = emptyAnswerModel
            answer.id = documentData["id"] as! String
            answer.body = documentData["body"] as! String
            answer.profileId = documentData["profileId"] as! String
            answer.questionId = documentData["questionId"] as! String
            
            answers.append(answer)
        }
        return answers
    }
    
    public func GetRecent() async throws -> [AnswerModel] {
        var answers: [AnswerModel] = []
        let snapshot = try await db.collection("answers")
            .limit(to: 10)
            .getDocuments()
        
        snapshot.documents.forEach { documentSnapshot in
            let documentData = documentSnapshot.data()
            
            var answer: AnswerModel = emptyAnswerModel
            answer.id = documentData["id"] as! String
            answer.body = documentData["body"] as! String
            answer.profileId = documentData["profileId"] as! String
            answer.questionId = documentData["questionId"] as! String
            
            answers.append(answer)
        }
        return answers
    }
    
    
    public func Save(answer: AnswerModel) async throws {
        do {
            try db.collection("answers").document(answer.id).setData(from: answer)
        } catch let error {
            print(error)
        }
    }
    
}
