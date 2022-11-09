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
               
                
                VStack{
                    Text("Create Account")
                        .bold()
                        .font(.system(size: 30))
                    
                    Text("blahb bblah balh")
                        .font(.system(size: 20))
                }
                
                VStack{
                    SignUpCredentialFields(email: $email, password: $password, passwordConfirmation: $passwordConfirmation)
                    Button(action: {
                        signUpUser(userEmail: email, userPassword: password)
                    }) {
                        Text("Sign Up")
                            .bold()
                            .foregroundColor(Color.blue)
                            .frame(width: 360, height: 50)
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    .frame(width: 300, height: 25)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .textInputAutocapitalization(.never)
                    .overlay(RoundedRectangle(cornerRadius:20)
                        .stroke(Color.blue, lineWidth: 3))
                }
                .padding(.bottom,100)
                
                Text("or sign up with")
                ThirdPartyButtons()
           
                
                HStack{
                    Text("Already have an account?")
              NavigationLink(destination:
                                SignInView()) {
                  Text("Log In")
              }
                }
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
                .frame(width: 300, height: 25)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray)
                )
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
                .frame(width: 300, height: 25)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(10)
                .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray)
                )
            
            SecureField("Confirm Password", text: $passwordConfirmation)
                .frame(width: 300, height: 25)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(10)
                .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray)
                )
                .border(Color.red, width: passwordConfirmation != password ? 1: 0)
                .padding(.bottom, 30)
                .disableAutocorrection(true)
        }
    }
    
}
