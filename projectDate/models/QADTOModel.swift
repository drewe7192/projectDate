//
//  QADTOModel.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 6/29/25.
//

import Foundation
import UIKit

struct QADTOModel: Equatable, Hashable {
    var profileId: String
    var profileImage: UIImage
}

var emptyQADTOModel = QADTOModel(profileId: "", profileImage: UIImage())
