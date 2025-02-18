//
//  MotherView.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/4/22.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    init() {
        //Change the menuBar color to white
        UITabBar.appearance().backgroundColor = UIColor.darkGray
    }
    
    var body: some View {
        GeometryReader{geoReader in
            switch viewRouter.currentPage {
            case .homePage :
                HomeView()
            case .signUpPage:
                SignUpView()
            case .signInPage:
                SignInView()
            default:
                SignInView()
            }
        }
    }
    
    #Preview {
        ContentView().environmentObject(ViewRouter())
    }
}
