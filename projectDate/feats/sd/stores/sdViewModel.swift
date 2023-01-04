//
//  sdViewModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/3/23.
//

import Foundation

class sdViewModel: ObservableObject {
    @Published var sd: sdModel = MockService.sdSampleData
    
    init(forPreview: Bool = false){
        if forPreview {
            sd = MockService.sdSampleData
        }
    }
}
