//
//  MotherView.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/4/22.
//

import SwiftUI

struct MotherView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        switch viewRouter.currentPage {
        case .signUpPage :
            SignUpView()
        case .signInPage:
            SignInView()
        case .homePage:
            HomeView()
        }
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView().environmentObject(ViewRouter())
    }
}
