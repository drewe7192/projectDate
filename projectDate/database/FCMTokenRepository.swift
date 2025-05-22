//
//  FCMTokenRepository.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 5/21/25.
//

import Foundation
import Firebase

class FCMTokenRepository {
    let db = Firestore.firestore()
    
    public func Get(userId: String) async throws -> FCMTokenModel {
        var fcmToken = emptyFCMTokenModel
        let snapshot = try await db.collection("fcmTokens")
            .whereField("userId", isEqualTo: userId as String)
            .getDocuments()
        
        snapshot.documents.forEach { documentSnapshot in
            let documentData = documentSnapshot.data()
            
            fcmToken.id = documentData["id"] as! String
            fcmToken.token = documentData["token"] as! String
        }
        return fcmToken
    }
}
