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
                
                ScrollView{
                    VStack(spacing: 20) {
                        ForEach(0..<10) {
                            Text("Item \($0)")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .frame(width: 200, height: 200)
                                .background(.red)
                        }
                    }
                    
                }
                .frame(height: 350)
        
                
                NavigationLink(destination: MatchBoxMainView()){
                    Text("00:00")
                }
                .frame(width: 300, height: 25)
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .textInputAutocapitalization(.never)
                .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 3))
                
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
