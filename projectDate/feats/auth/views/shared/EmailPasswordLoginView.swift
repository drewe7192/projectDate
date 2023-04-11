//
//  EmailPasswordLoginView.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/19/23.
//

import SwiftUI
import FirebaseAuth

struct EmailPasswordLoginView: View{
    @EnvironmentObject var viewRouter: ViewRouter
    
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @Binding var signInErrorMessage: String
    @Binding var displayConfirmPassword: Bool
    
    var body: some View{
        VStack{
            CredentialFieldsView(email: $email, password: $password, confirmPassword: $confirmPassword, displayConfirmPassword: $displayConfirmPassword)
            
            Spacer()
                .frame(height: 20)
            
            //logIn Button
            Button(action: {
                if(displayConfirmPassword){
                    createUser(userEmail: email, userPassword: password)
                } else {
                    signInUser(userEmail: email, userPassword: password)
                }
                
            }) {
                Text("Login")
                    .bold()
                    .foregroundColor(.black)
                    .frame(width: 340, height: 25)
                    .padding()
                    .background(Color.iceBreakrrrPink)
                    .cornerRadius(10)
                    .textInputAutocapitalization(.never)
                    .shadow(radius: 5)
                    .opacity(!email.isEmpty && !password.isEmpty && (displayConfirmPassword ? !confirmPassword.isEmpty : true ) ? 1 : 0.5)
            }
            .disabled(!email.isEmpty && !password.isEmpty && (displayConfirmPassword ? !confirmPassword.isEmpty : true ) ? false : true)
        }
        
    }
    
   private func signInUser(userEmail: String, userPassword: String){
        LogInItems(isSignInPage: true).isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            guard error ==  nil else{
                LogInItems(isSignInPage: true).isLoading  = false
                signInErrorMessage = error!.localizedDescription
                return
            }
            switch authResult {
            case .none:
                print("Cound not sign in user.")
                LogInItems(isSignInPage: true).isLoading  = false
            case .some(_):
                print("User signed in")
                LogInItems(isSignInPage: true).isLoading = false
                viewRouter.currentPage = .homePage
            }
        }
    }
    
    private func createUser(userEmail: String, userPassword: String){
        LogInItems(isSignInPage: true).isLoading = true
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            guard error == nil else{
                LogInItems(isSignInPage: true).isLoading = false
                signInErrorMessage = error!.localizedDescription
                return
            }
            switch authResult {
            case .none:
                print("Cound not create new user.")
                LogInItems(isSignInPage: true).isLoading = false
            case .some(_):
                print("User signed in")
                LogInItems(isSignInPage: true).isLoading = false
                viewRouter.currentPage = .homePage
                
            }
        }
    }
}

struct EmailPasswordLoginView_Previews: PreviewProvider {
    static var previews: some View {
        EmailPasswordLoginView(email: .constant(""), password: .constant(""),confirmPassword: .constant(""),signInErrorMessage: .constant(""), displayConfirmPassword: .constant(true))
    }
}
