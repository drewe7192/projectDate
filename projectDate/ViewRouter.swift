//
//  ViewRouter.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/4/22.
//

import SwiftUI

class ViewRouter: ObservableObject {
    
    @Published var currentPage: Pawge = .signUpPage
}

enum Pawge {
    case signUpPage
    case signInPage
    case homePage
}
