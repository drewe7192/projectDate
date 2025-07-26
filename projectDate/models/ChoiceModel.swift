//
//  ChoiceModel.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 7/25/25.
//

import Foundation
import UIKit

struct ChoiceModel: Identifiable, Equatable, Hashable, Decodable {
    var id: String
    var text: String
    var isSelected: Bool = false
}

var emptyChoiceModel = ChoiceModel(id: "", text: "")
