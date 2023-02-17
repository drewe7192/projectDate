//
//  SettingsView.swift
//  DatingApp
//
//  Created by DotZ3R0 on 8/1/22.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn

struct SettingsView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State var isLoggedOut = false
    
    var body: some View {
        VStack{
            Text("Hello Settings view")
            
            Button(action: {
                signOutUser()
            }) {
                Text("Sign Out")
            }
            .fullScreenCover(isPresented: $isLoggedOut) {
                SignInView()
            }
        }
    }

    func signOutUser(){
        let firebaseAuth = Auth.auth()
        do{
            //Google sign out..
//            GIDSignIn.sharedInstance.signOut()
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        viewRouter.currentPage = .signInPage
        isLoggedOut = true
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
