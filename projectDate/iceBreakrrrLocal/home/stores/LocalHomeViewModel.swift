//
//  LocalHomeViewModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import Foundation

class LocalHomeViewModel: ObservableObject {
    @Published var swipeCards: [ProfileModel] = MockService.swipeCardsProfilesSampleData.profiles
    
    init(forPreview: Bool = false) {
        if forPreview {
            swipeCards = MockService.swipeCardsProfilesSampleData.profiles
        }
    }
}

