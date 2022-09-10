//
//  GoogleAuth.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/10/22.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct GoogleAuth: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var isLoading: Bool = false
    
    var body: some View {
        Button{
            handleGoogleLogin()
        } label: {
            HStack(spacing: 15){
                Text("Create Google Account")
                    .font(.title3)
                    .fontWeight(.medium)
                    .kerning(1.1)
            }
            .foregroundColor(Color.blue)
            .padding()
            .frame(maxWidth: .infinity)
            
            .background(
            Capsule()
                .strokeBorder(Color.blue)
            )
        }
        .padding(.top,25)
    }
    
    func handleGoogleLogin(){
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        isLoading = true
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()) {
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
                viewRouter.currentPage = .homePage
            }
        }
    }
}

struct GoogleAuth_Previews: PreviewProvider {
    static var previews: some View {
        GoogleAuth()
    }
}
