//
//  SignInView.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/4/22.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct SignInView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var signInProcessing = false
    @State var signInErrorMessage = ""
    @State var email = ""
    @State var password =  ""
    
    
    var body: some View {
        VStack(spacing: 15){
            LogoView()
            Spacer()
            SignInCredentialFields(email: $email, password: $password)
            Button(action: {
                signInUser(userEmail: email, userPassword: password)
            }) {
                Text("Log In")
                    .bold()
                    .frame(width: 360, height: 50)
                    .background(.thinMaterial)
                    .cornerRadius(10)
            }
            .disabled(!signInProcessing && !email.isEmpty && !password.isEmpty ? false : true)
            
            Spacer()
            HStack{
                Text("Don't have an account?")
                Button(action: {
                    viewRouter.currentPage = .signUpPage
                }) {
                    Text("Sign Up")
                }
            }
            
            if signInProcessing {
                ProgressView()
            }
            
            if !signInErrorMessage.isEmpty {
                Text("Failed creating account: \(signInErrorMessage)")
                    .foregroundColor(.red)
            }
        }
     
        
    }
    
    func signInUser(userEmail: String, userPassword: String){
        signInProcessing = true
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            guard error ==  nil else{
                signInProcessing = false
                signInErrorMessage = error!.localizedDescription
                return
            }
            switch authResult {
            case .none:
                print("Cound not sign in user.")
                signInProcessing = false
            case .some(_):
                print("User signed in")
                signInProcessing = false
                withAnimation{
                    viewRouter.currentPage = .homePage
                }
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

struct SignInCredentialFields: View {
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        Group{
            TextField("Email", text: $email)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(10)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(10)
                .padding(.bottom, 30)
        }
    }
    
}
