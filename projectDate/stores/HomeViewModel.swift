//
//  HomeViewModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/29/22.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var people: [Profile] = []
    @Published var user: User = MockService.userSampleData
    
    init(forPreview: Bool = false) {
        if forPreview {
            people = MockService.sampleData
            user = MockService.userSampleData
        }
    }
    
}
