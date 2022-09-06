//
//  HomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 8/3/22.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct HomeView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var signOutProcessing = false
    
    var body: some View {
        Text("This is the Home Screen")
        Button(action: {
            signOutUser()
        }) {
            Text("Sign Out")
        }
    }
    
    func signOutUser(){
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        withAnimation{
            viewRouter.currentPage = .signInPage
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
