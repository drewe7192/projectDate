//
//  FacebookAuth.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/11/22.
//

import SwiftUI
import FBSDKLoginKit
import Firebase

struct FacebookLoginView: UIViewRepresentable {
    @Binding var showAlert: Bool
    @EnvironmentObject var viewRouter: ViewRouter
    
    func makeUIView(context: UIViewRepresentableContext<FacebookLoginView>) -> FBLoginButton {
        let view = FBLoginButton()
        view.permissions = ["email"]
        view.delegate = context.coordinator
        //these 2 lines change the text on the button
        let buttonText = NSAttributedString(string: "Sign in with facebook")
        view.setAttributedTitle(buttonText, for: .normal)
        return view
    }
    
    func updateUIView(_ uiView: FBLoginButton, context: UIViewRepresentableContext<FacebookLoginView>) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, LoginButtonDelegate {
        var parent: FacebookLoginView
        
        init(_ parent: FacebookLoginView) {
            self.parent = parent
        }
        
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?){
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    // this provides an alert. Probably need to make a condition for account already exists
                    self.parent.showAlert = true
                    //very important: the fblogButton needs to logout from fb servers as well as Firebase
                    LoginManager().logOut()
                    return
                }
                print("Facebook Sign in")
                self.parent.viewRouter.currentPage = .homePage
            }
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            try! Auth.auth().signOut()
        }
    }
}

