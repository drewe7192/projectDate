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
    
    public func Save(answer: AnswerModel) async throws {
        do {
            try db.collection("answers").document(answer.id).setData(from: answer)
        } catch let error {
            print(error)
        }
    }
}
