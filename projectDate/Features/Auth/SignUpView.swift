//
//  SignUpView.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/4/22.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct SignUpView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var signupProcessing = false
    @State var email = ""
    @State var password = ""
    @State var passwordConfirmation = ""
    
    var body: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 15){
               
                
                LogoView()
                Spacer()
                SignUpCredentialFields(email: $email, password: $password, passwordConfirmation: $passwordConfirmation)
                Button(action: {
                    signUpUser(userEmail: email, userPassword: password)
                }) {
                    Text("Sign Up")
                        .bold()
                        .frame(width: 360, height: 50)
                        .background(.thinMaterial)
                        .cornerRadius(10)
                }
                Spacer()
                HStack{
                    Text("Already have an account?")
                    Button(action: {
                        viewRouter.currentPage = .signInPage
                    }) {
                        Text("Log In")
                    }
                }
                .opacity(0.9)
                .disabled(!signupProcessing && !email.isEmpty && !password.isEmpty && !passwordConfirmation.isEmpty && password == passwordConfirmation ? false : true)
            }
            .padding()
            
        }
      
    }
    
    func signUpUser(userEmail: String, userPassword: String){
        signupProcessing = true
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
            guard error == nil else {
                signupProcessing = false
                return
            }
            
            switch authResult {
            case.none:
                print("Could not create account")
                signupProcessing = false
            case .some(_):
                print("User created")
                signupProcessing = false
                viewRouter.currentPage = .homePage
            }
        }
    }
}



struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

struct SignUpCredentialFields: View {
    
    @Binding var email: String
    @Binding var password: String
    @Binding var passwordConfirmation: String
    
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
                .disableAutocorrection(true)
            SecureField("Confirm Password", text: $passwordConfirmation)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(10)
                .border(Color.red, width: passwordConfirmation != password ? 1: 0)
                .padding(.bottom, 30)
                .disableAutocorrection(true)
        }
    }
    
}

struct LogoView: View {
    var body: some View {
        Image("sasuke")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: 150)
            .padding(.top, 70)
    }
}
