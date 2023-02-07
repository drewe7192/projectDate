//
//  ViewRouter.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/4/22.
//

import SwiftUI

class ViewRouter: ObservableObject {
    static let shared = ViewRouter()
    @Published var currentPage: Route = .signInPage
}

enum Route {
    case signUpPage
    case signInPage
    case homePage
}
