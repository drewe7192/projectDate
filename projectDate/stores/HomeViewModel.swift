//
//  HomeViewModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/29/22.
//ß

import Foundation

class HomeViewModel: ObservableObject {
    @Published var people: [ProfileModel] = MockService.profilesSampleData
    @Published var user: UserModel = MockService.userSampleData
    @Published var tabTitles: Array = MockService.homeTabTitles
    
    init(forPreview: Bool = false) {
        if forPreview {
            people = MockService.profilesSampleData
            user = MockService.userSampleData
            tabTitles = MockService.homeTabTitles
        }
    }
}
