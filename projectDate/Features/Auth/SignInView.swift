//
//  SignInView.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/4/22.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

struct SignInView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var signInErrorMessage = ""
    @State var email = ""
    @State var password =  ""
    @State var isLoading: Bool = false
    @State var isLoggedIn: Bool = false
    @State var signInProcessing = false
    @State var isThirdPartyAuth = false
    
    var body: some View {
        
        // without these 3 lines background will be black
        ZStack{
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 15){
                LogoView()
                    .padding(.bottom)
               
                // other logIn Buttons...
                if (isThirdPartyAuth){
                    ThirdPartyLogInButtons()
                }else{
                    EmailPasswordLogIn(email: $email, password: $password, signInProcessing: $signInProcessing, signInErrorMessage: $signInErrorMessage)
                }
              
                Button(action: {
                    self.isThirdPartyAuth.toggle()
                }) {
                    Text("Sign in with 3rd party")
                        .bold()
                        .foregroundColor(Color.green)
                        .frame(width: 360, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .frame(width: 300, height: 25)
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .textInputAutocapitalization(.never)
                .overlay(
                    RoundedRectangle(cornerRadius: 20).stroke(Color.green, lineWidth: 3)
                )
                .padding(.bottom,25)
      
                //Spacer()
                
                //footer...
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
            }
            .overlay(
                // Is Loading Indicator...
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
            )
        }
    }
    
    
}


struct SignInCredentialFields: View {
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        Group{
            TextField("Email", text: $email)
                .frame(width: 300, height: 25)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(20)
                .textInputAutocapitalization(.never)
                .overlay(
                    RoundedRectangle(cornerRadius: 20).stroke(Color.gray)
                )
            SecureField("Password", text: $password)
                .frame(width: 300, height: 25)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20).stroke(Color.gray)
                )
                .padding(.bottom,25)
        }
    }
    
}

struct EmailPasswordLogIn: View{
    @Binding var email: String
    @Binding var password: String
    @Binding var signInProcessing: Bool
    @Binding var signInErrorMessage: String
    
    var body: some View{
        SignInCredentialFields(email: $email, password: $password)
           
        //logIn Button
        Button(action: {
            signInUser(userEmail: email, userPassword: password)
        }) {
            Text("Log In")
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
        .overlay(
            RoundedRectangle(cornerRadius: 20).stroke(Color.blue, lineWidth: 3)
        )
        .disabled(!signInProcessing && !email.isEmpty && !password.isEmpty ? false : true)
        .padding(.bottom,25)
        
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
                SignInView().viewRouter.currentPage = .homePage
                
            }
        }
    }
}
struct ThirdPartyLogInButtons: View{
    var body: some View{
        FacebookAuth()
        AppleAuth()
        GoogleAuth()
            .padding(.bottom,30)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignInView()
                .previewInterfaceOrientation(.portrait)
        }
    }
}





