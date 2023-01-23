//
//  LocalHomeViewModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import Foundation

class LocalHomeViewModel: ObservableObject {
    @Published var swipeCards: [QuestionModel] = MockService.swipeCardsQuestionsSampleData.questions
    
    init(forPreview: Bool = false) {
        if forPreview {
            swipeCards = MockService.swipeCardsQuestionsSampleData.questions
        }
    }
}

