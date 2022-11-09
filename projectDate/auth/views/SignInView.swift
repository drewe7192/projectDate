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
    @State var isThirdPartyAuth = true
    
    var body: some View {
        
        NavigationView {
            
            // without these 3 lines background will be black
            ZStack{
                Color.white
                    .ignoresSafeArea()

                VStack(spacing: 10){
                   
                    VStack{
                        Text("Hello Again")
                            .bold()
                            .font(.system(size: 30))
                        
                        Text("blah nblah subtitle blah")
                            .font(.system(size: 20))
                    }
                    
                    EmailPasswordLogIn(email: $email, password: $password, signInProcessing: $signInProcessing, signInErrorMessage: $signInErrorMessage, isLoggedIn: $isLoggedIn)
                    
                        Text("or continue with")
              
                    ThirdPartyButtons()
                    
//                    Button(action: {
//                        self.isThirdPartyAuth.toggle()
//                    }) {
//                        Text("Sign in with 3rd party")
//                            .bold()
//                            .foregroundColor(Color.green)
//                            .frame(width: 360, height: 50)
//                            .background(Color.white)
//                            .cornerRadius(10)
//                    }
//                    .frame(width: 300, height: 25)
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(20)
//                    .textInputAutocapitalization(.never)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 20).stroke(Color.green, lineWidth: 3)
//                    )
//                    .padding(.bottom,25)
                    
                    //footer...
                  
                        HStack{
                            Text("Don't have an account?")
                                .foregroundColor(Color.black)
                            NavigationLink(destination: SignUpView()) {
                                Text("Sign up")
                            }
                        }
                        .padding(.bottom,80)
                    
                   
                    
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
                .fullScreenCover(isPresented: $isLoggedIn) {
                    HomeView()
                }
                
            }
            
            
            
        }
       
    }
    
    
}

struct SignInCredentialFields: View {
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        Group{
            VStack{
                TextField("Email", text: $email)
                    .frame(width: 300, height: 25)
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(20)
                    .textInputAutocapitalization(.never)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20).stroke(Color.gray)
                    )
                    .padding(.bottom,10)
                
                SecureField("Password", text: $password)
                    .frame(width: 300, height: 25)
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20).stroke(Color.gray)
                    )
            }
            .padding(.bottom, 60)

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
        .padding(.bottom,130)
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

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignInView()
                .previewInterfaceOrientation(.portrait)
        }
    }
}





