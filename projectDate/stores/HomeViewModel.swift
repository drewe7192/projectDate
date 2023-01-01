//
//  HomeViewModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/29/22.
//ß

import Foundation

class HomeViewModel: ObservableObject {
    @Published var people: [ProfileModel] = MockService.profilesSampleData
    @Published var user: User = MockService.userSampleData
    
    init(forPreview: Bool = false) {
        if forPreview {
            people = MockService.profilesSampleData
            user = MockService.userSampleData
        }
    }
}
