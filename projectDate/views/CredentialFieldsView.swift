//
//  CredentialFieldsView.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/19/23.
//

import SwiftUI
import FirebaseAuth

struct CredentialFieldsView: View {
    @State var errorMessage: String = ""
    @EnvironmentObject var viewRouter: ViewRouter
    @Binding var email: String
    @Binding var password: String

    let isSignInView: Bool
    
    var body: some View {
        ZStack{
            Color.primaryColor
                .ignoresSafeArea()
            
            VStack{
                HStack{
                    Text("Email:")
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                    
                    Spacer()
                }
                
                TextField("", text: $email)
                    .foregroundColor(.white)
                    .frame(width: 340, height: 25)
                    .padding()
                    .cornerRadius(10)
                    .textInputAutocapitalization(.never)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
                    )
                    .padding(.bottom,3)
                
                HStack{
                    Text("Password:")
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                    
                    Spacer()
                }
                SecureField("", text: $password)
                    .frame(width: 340, height: 25)
                    .padding()
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
                    )
                Spacer()
                    .frame(height: 20)
                
                //logIn Button
                Button(action: {
                    if(isSignInView){
                        signInUser(userEmail: email, userPassword: password)
                    } else {
                        createUser(userEmail: email, userPassword: password)
                    }
                }) {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.blue, lineWidth: 2)
                        .frame(width: 340, height: 50)
                        .animation(.easeInOut, value: true)
                        .overlay {
                            Text(isSignInView ? "Login" : "Sign Up")
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 340, height: 25)
                                .padding()
                                .cornerRadius(10)
                                .textInputAutocapitalization(.never)
                                .shadow(radius: 5)
                        }
                }
                .disabled(!email.isEmpty && !password.isEmpty ? false : true)
                .opacity(!email.isEmpty && !password.isEmpty ? 1 : 0.2)
            }
        }
    }
    
    private func signInUser(userEmail: String, userPassword: String){
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard error ==  nil else{
                self.errorMessage = error!.localizedDescription
                return
            }
            switch authResult {
            case .none:
                print("Cound not sign in user.")
            case .some(_):
                print("User signed in")
                viewRouter.currentPage = .homePage
            }
        }
    }
    
    private func createUser(userEmail: String, userPassword: String){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard error == nil else{
                self.errorMessage = error!.localizedDescription
                return
            }
            switch authResult {
            case .none:
                print("Cound not create new user.")
            case .some(_):
                print("User signed in")
                viewRouter.currentPage = .homePage
            }
        }
    }
}

struct CredentialFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        CredentialFieldsView(email: .constant(""), password: .constant(""), isSignInView: true)
    }
}
