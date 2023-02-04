//
//  LogInItems.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/29/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

struct LogInItems: View {
    @State var toggleButtons = false

    @State var signInErrorMessage = ""
    @State var email = ""
    @State var password =  ""
    @State var isLoading: Bool = true
    @State var isLoggedIn: Bool = false
    @State var signInProcessing = false
    @State var isThirdPartyAuth = true


    var body: some View {
            if(toggleButtons){
                thirdPartyButtons
            } else {
                initalButtons
            }
    }

     var initalButtons: some View {
        HStack{
            Button(action: {
                self.toggleButtons.toggle()
            }) {
                Image("appleLogo")
                    .resizable()
                    .frame(width: 35, height: 35)
            }
            .frame(width: 120, height: 50)
            .background(.white)
            .cornerRadius(15)
            .shadow(radius: 5)

            Button(action: {
                self.toggleButtons.toggle()
            }) {
                Image("googleLogo")
                    .resizable()
                    .frame(width: 35, height: 35)
            }
            .frame(width: 120, height: 50)
            .background(.white)
            .cornerRadius(15)
            .shadow(radius: 5)

            Button(action: {
                self.toggleButtons.toggle()
            }) {
                Image("facebookLogo")
                    .resizable()
                    .frame(width: 35, height: 35)
            }
            .frame(width: 120, height: 50)
            .background(.white)
            .cornerRadius(15)
            .shadow(radius: 5)
        }

    }

    var thirdPartyButtons: some View {
       VStack{
           FacebookAuth()
           AppleAuth()
           GoogleAuth()
       }
   }

     var loadingIndicator: some View {
        ZStack{
            if isLoading{
                Color.black
                    .opacity(0.25)
                    .ignoresSafeArea()

                ProgressView()
                    .font(.title2)
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .cornerRadius(10)
            }
        }
    }

     var signUpLinkSection: some View {
        HStack{
            Text("Don't have an account?")
                .foregroundColor(Color.black)
            NavigationLink(destination: SignUpView()) {
                Text("Sign up")
            }
        }
    }

}

struct SignInCredentialFields: View {
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        ZStack{
            // Use this color to help see the fields better in preview
//            Color(.systemPink)
//                .ignoresSafeArea()
            
            Group{
                VStack{
                    ZStack{
                        // using 2 text fields to get the proper effect I want:
                        // a faded background inside textField but text is still bold
                        //and visible
                        TextField("", text: $email)
                            .foregroundColor(.black)
                            .frame(width: 340, height: 25)
                            .padding()
                            .background(.white)
                            .opacity(0.3)
                            .cornerRadius(10)
                            .textInputAutocapitalization(.never)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
                            )
                            .padding(.bottom,3)
                        
                        TextField("Email", text: $email)
                            .foregroundColor(.white)
                            .frame(width: 340, height: 25)
                            .padding()
                            .cornerRadius(10)
                            .textInputAutocapitalization(.never)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
                            )
                            .padding(.bottom,3)
                    }
                    
                    ZStack{
                        // using 2 text fields to get the proper effect I want:
                        // a faded background inside textField but text is still bold
                        //and visible
                        SecureField("", text: $password)
                            .frame(width: 340, height: 25)
                            .padding()
                            .background(.white)
                            .opacity(0.3)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
                            )
                        
                        SecureField("Password", text: $password)
                            .frame(width: 340, height: 25)
                            .padding()
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
                            )
                    }
                    
                 
                }
                
            }
        }
   
    }
}

struct EmailPasswordLogIn: View{
    @EnvironmentObject var viewRouter: ViewRouter
    @Binding var email: String
    @Binding var password: String
    @Binding var signInProcessing: Bool
    @Binding var signInErrorMessage: String
    @Binding var isLoggedIn: Bool
    
    var body: some View{
        SignInCredentialFields(email: $email, password: $password)
        
        //logIn Button
        Button(action: {
            signInUser(userEmail: email, userPassword: password)
        }) {
            Text("Login")
                .bold()
                .foregroundColor(.black)
                .background(Color.white)
        }
        .frame(width: 340, height: 25)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .textInputAutocapitalization(.never)
        .shadow(radius: 5)
        .disabled(!signInProcessing && !email.isEmpty && !password.isEmpty ? false : true)
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
                isLoggedIn = true
                
            }
        }
    }
}

struct LogInItems_Previews: PreviewProvider {
    static var previews: some View {
        LogInItems()
//        SignInCredentialFields(email: .constant("vdffdd"), password: .constant("fdsfds"))
    }
}
