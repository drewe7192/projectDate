//
//  GoogleAuth.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/10/22.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn

struct GoogleAuth: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State var isLoggedIn: Bool  = false
    
    var body: some View {
        Button{
            GoogleLogIn(isLoggedIn: $isLoggedIn).handleGoogleLogin()
        } label: {
            Text("Sign in with Google")
                .font(.title3)
                .fontWeight(.medium)
                .kerning(1.1)
                .foregroundColor(.white)
                .frame(width: 400, height: 60)
                .background(.red)
                .cornerRadius(20)
                .shadow(radius: 5)
        }
        .frame(width: 350)
        .fullScreenCover( isPresented: $isLoggedIn){
            HomeView()
        }
    }
}

struct GoogleLogIn {
    @State var isLoading: Bool = false
    @Binding var isLoggedIn: Bool
    
    func handleGoogleLogin(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        isLoading = true
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: GoogleAuth().getRootViewController()) {
            [self] user, err in
            
            if let error = err {
                isLoading = false
                print(error.localizedDescription)
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                isLoading = false
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken:
                                                            authentication.accessToken)
            
            //Firebase Auth...
            Auth.auth().signIn(with: credential) { result, err in
                
                isLoading = false
                
                if let error = err {
                    print(error.localizedDescription)
                    return
                }
                
                //Displaying User Name...
                guard let user = result?.user else{
                    return
                }
                print(user.displayName ?? "Sucess!")
                isLoggedIn = true
            }
        }
    }
}

struct GoogleAuth_Previews: PreviewProvider {
    static var previews: some View {
        GoogleAuth()
    }
}





