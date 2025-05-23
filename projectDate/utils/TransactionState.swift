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
    case analyzing = "Waiting for guest's answer"
    case processing =  "Checking for Match"
    case completed = "It's a match!"
    case failed = "Not a match. Leaving Session"
    
    var color: Color {
        switch self {
        case .idle:
            return .black
        case .analyzing:
            return .blue
        case .processing:
            return Color(red: 0.8, green: 0.35, blue: 0.2)
        case .completed:
            return .green
        case .failed:
            return .red
        }
    }
    
    var image: String? {
        switch self {
        case .idle: "heart"
        case .analyzing: nil
        case .processing: nil
        case .completed: "checkmark.circle.fill"
        case .failed: "xmark.circle.fill"
        }
    }
}
