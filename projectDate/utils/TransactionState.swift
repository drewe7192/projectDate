//
//  TransactionState.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 5/7/25.
//

import Foundation
import SwiftUI

enum TransactionState: String {
    case idle = "Click to match"
    case answerSubmitted = "Answer submitted! Waiting on participant"
    case waitingForResponse = "User submitted answer! Waiting for you..."
    case analyzingAnswers =  "Answers submitted! Checking for Match"
    case success = "It's a match!"
    case failed = "Not a match. Leaving Session"
    
    var color: Color {
        switch self {
        case .idle:
            return .black
        case .answerSubmitted:
            return .blue
        case .waitingForResponse:
            return .pink
        case .analyzingAnswers:
            return Color(red: 0.8, green: 0.35, blue: 0.2)
        case .success:
            return .green
        case .failed:
            return .red
        }
    }
    
    var image: String? {
        switch self {
        case .idle: "heart"
        case .answerSubmitted: nil
        case .waitingForResponse: nil
        case .analyzingAnswers: nil
        case .success: "checkmark.circle.fill"
        case .failed: "xmark.circle.fill"
        }
    }
}
