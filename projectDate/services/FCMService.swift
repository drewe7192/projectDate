//
//  FCMService.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 5/21/25.
//

import Foundation
import Firebase

class FCMService {
    private let fcmTokenRepo = FCMTokenRepository()
    
    public func getFCMToken(userId: String) async throws -> FCMTokenModel{
        let fcmToken = try await fcmTokenRepo.get(userId: userId)
        return fcmToken
    }
}
