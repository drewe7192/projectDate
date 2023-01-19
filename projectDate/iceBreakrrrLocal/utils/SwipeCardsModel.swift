//
//  testModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import Foundation
import SwiftUI

struct SwipeCardsModel: Identifiable {
    var id: Int
    let firstName: String
    let lastName: String
    let start: Color
    let end: Color
    let profiles: [ProfileModel]
}
