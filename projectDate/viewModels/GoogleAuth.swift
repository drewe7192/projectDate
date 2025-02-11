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
    @Binding var showAlert: Bool
    
    var body: some View {
        Button(action: {
            GoogleLogIn(showAlert: $showAlert).handleGoogleLogin() { (success) -> Void in
                if success {
                        viewRouter.currentPage = .homePage
                }
            }
        }) {
            Text("Sign in with Google")
                .font(.title3)
                .fontWeight(.medium)
                .kerning(1.1)
                .foregroundColor(.white)
                .frame(width: 350, height: 60)
                .background(.red)
                .cornerRadius(20)
                .shadow(radius: 5)
        }
        .frame(width: 350)
    }
}

struct GoogleLogIn {
    @State var isLoading: Bool = false
    @Binding var showAlert: Bool
    
    func handleGoogleLogin(completion: @escaping (_ success: Bool) -> Void){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: GoogleAuth(showAlert: $showAlert).getRootViewController()) { [self] user, err in
            
            if let error = err {
                isLoading = false
                print(error.localizedDescription)
                
                return
            }
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken:
                                                            authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { result, err in
                
                if let error = err {
                    print(error.localizedDescription)
                    //dont really need this cause Google signIn overrides the Facebook signIn in Firebase for some reason
                    showAlert = true
                    return
                }
                
                //Displaying User Name...
                guard let user = result?.user else{
                    return
                }
                print(user.displayName ?? "Sucess!")
                completion(true)
            }
        }
    }
}

struct GoogleAuth_Previews: PreviewProvider {
    static var previews: some View {
        GoogleAuth(showAlert: Binding<Bool>.constant(false))
    }
}





