//
//  speedDateViewModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 4/4/23.
//

import Foundation

class speedDateViewModel: ObservableObject {
    @Published var sd: speedDateModel = MockService.sdSampleData
    
    init(forPreview: Bool = false){
        if forPreview {
            sd = MockService.sdSampleData
        }
    }
}
