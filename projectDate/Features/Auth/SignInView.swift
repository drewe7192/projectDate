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

struct SignInView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var signInProcessing = false
    @State var signInErrorMessage = ""
    @State var email = ""
    @State var password =  ""
    @State var isLoading: Bool = false
    
    
    var body: some View {
        ZStack{
            
            Color.white
                .ignoresSafeArea()
            
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
                // Sign in Buttons...
                AppleAuth()
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

extension View {
    func getRootViewController()->UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}
