//
//  EventModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/21/23.
//

import Foundation


struct EventModel: Identifiable {
    var id: Int
    var title: String
    var location: String
    var creationDate: Date
    var description: String
    var participants: [ProfileModel?]
    var eventDate: Date
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd 'of' MMMM"
        return formatter.string(from: eventDate)
    }
}
