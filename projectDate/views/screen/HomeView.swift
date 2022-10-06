//
//  HomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 8/3/22.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn

struct HomeView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var signOutProcessing = false
    @State var isLoggedOut = false
    
    var body: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
            VStack{
                Text("This is the Home Screen")
                    .foregroundColor(Color.black)
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
    }
    
    func signOutUser(){
        let firebaseAuth = Auth.auth()
        do{
            //Google sign out..
            GIDSignIn.sharedInstance.signOut()
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        viewRouter.currentPage = .signInPage
        isLoggedOut = true
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
