//
//  EventViewModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/21/23.
//

import Foundation

class EventViewModel: ObservableObject {
    @Published var events: [EventModel] = MockService.eventsSampleData
    
    init(forPreview: Bool = false) {
        if forPreview {
            events = MockService.eventsSampleData
        }
    }
}
