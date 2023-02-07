//
//  FacebookAuth.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/11/22.
//

import SwiftUI

struct FacebookAuth: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var fbmanager = FacebookSignInManager()
    
    var body: some View {
        Button(action: {
            self.fbmanager.facebookLogin() { (success) -> Void in
                if success {
                    if(fbmanager.isLoggedIn){
                        viewRouter.currentPage = .homePage
                    }
                }
            }
        }) {
            
            Text("Sign in with Facebook")
                .font(.title3)
                .fontWeight(.medium)
                .kerning(1.1)
                .foregroundColor(.white)
                .frame(width: 400, height: 60)
                .background(.blue)
                .cornerRadius(20)
                .shadow(radius: 5)
        }
        .frame(width: 350)
    }
}

struct FacebookAuth_Previews: PreviewProvider {
    static var previews: some View {
        FacebookAuth()
    }
}

