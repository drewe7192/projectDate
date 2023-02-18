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
    
    @State var signInErrorMessage = ""
    @State var email = ""
    @State var password =  ""
    @State var confirmPassword = ""
    @State var isLoggedIn: Bool = false
    @State var signInProcessing = false
    @State var isThirdPartyAuth = true
    
    enum signInType {
        case google, facebook, apple
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                // need a ZStack and color to change the background color
                LinearGradient(gradient: Gradient(colors: [.teal, .teal, .pink]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack{
                    headerSection
                    bodySection
                    
                    if signInProcessing {
                        ProgressView()
                    }
                }
                .overlay(
                    LogInItems().loadingIndicator
                )
                .fullScreenCover(isPresented: $isLoggedIn) {
                    HomeView()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var headerSection: some View {
        VStack{
            VStack{
                Text("Create Account,")
                    .foregroundColor(.white)
                    .bold()
                    .font(.system(size: 30))
                
                Text("To get started now!")
                    .foregroundColor(.white)
                    .font(.system(size: 30))
            }
            
            EmailPasswordLogIn(email: $email, password: $password, confirmPasword: $confirmPassword, signInProcessing: $signInProcessing, signInErrorMessage: $signInErrorMessage, isLoggedIn: $isLoggedIn)
        }
        
    }
    
    private var bodySection: some View {
        VStack{
            Text("or Sign Up with")
                .foregroundColor(.white)
                .padding(.bottom,20)
            
            LogInItems()
            
            signUpLinkSection
                .padding(.bottom,80)
        }
    }
    
    private var signUpLinkSection: some View {
        HStack{
            Text("Already have an account?")
                .foregroundColor(Color.black)
            NavigationLink(destination: SignInView()) {
                Text("Login Now")
            }
        }
    }
    
    struct CredentialFields: View {
        @Binding var email: String
        @Binding var password: String
        @Binding var confirmPassword: String
        
        var body: some View {
            Group{
                VStack{
                    SignInCredentialFields(email: $email, password: $password)
                        .padding(.bottom,3)
                    
                    ZStack{
                        SecureField("Confirm Password", text: $confirmPassword)
                            .frame(width: 340, height: 25)
                            .padding()
                            .background(.white)
                            .opacity(0.3)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
                            )
                        
                        SecureField("Confirm Password", text: $confirmPassword)
                            .frame(width: 340, height: 25)
                            .padding()
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
                            )
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }
    
    struct EmailPasswordLogIn: View{
        @EnvironmentObject var viewRouter: ViewRouter
        @Binding var email: String
        @Binding var password: String
        @Binding var confirmPasword: String
        @Binding var signInProcessing: Bool
        @Binding var signInErrorMessage: String
        @Binding var isLoggedIn: Bool
        
        var body: some View{
            CredentialFields(email: $email, password: $password, confirmPassword: $confirmPasword)
            
            //logIn Button
            Button(action: {
                signInUser(userEmail: email, userPassword: password)
            }) {
                Text("Sign Up")
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
            .padding(.bottom,70)
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
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}


