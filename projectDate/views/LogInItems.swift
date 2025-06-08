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
    @State var toggleButtons: Bool = false
    @State var signInErrorMessage: String = ""
    @State var email: String = ""
    @State var password: String =  ""
    @State var isLoading: Bool = false
    @State var showAlert: Bool = false
    
    let isSignInPage: Bool
    
    var body: some View {
        if(toggleButtons){
            thirdPartyButtons
        } else {
            initalButtons
        }
    }
    
    public var initalButtons: some View {
        VStack{
            if(isSignInPage) {
                Text("or Sign In with")
                    .foregroundColor(.white)
            } else {
                Text("or Sign Up with")
                    .foregroundColor(.white)
            }
            
            HStack{
                Button(action: {
                    self.toggleButtons.toggle()
                }) {
                    Image("appleLogo")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color.white)
                }
                .frame(width: 120, height: 50)
                .background(Color.secondaryColor)
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
                .background(Color.secondaryColor)
                .cornerRadius(15)
                .shadow(radius: 5)
                
//                Button(action: {
//                    self.toggleButtons.toggle()
//                }) {
//                    Image("facebookLogo")
//                        .resizable()
//                        .frame(width: 35, height: 35)
//                }
//                .frame(width: 120, height: 50)
//                .background(Color.secondaryColor)
//                .cornerRadius(15)
//                .shadow(radius: 5)
            }
            if(isSignInPage) {
                signUpLinkSection
            } else {
                signInLinkSection
            }
        }  
    }
    
    public var thirdPartyButtons: some View {
        VStack{
            if(isSignInPage) {
                Text("or Sign In with")
                    .foregroundColor(.white)
            } else {
                Text("or Sign Up with")
                    .foregroundColor(.white)
            }
           
            GoogleAuth(showAlert: $showAlert)
            
//            FacebookLoginView(showAlert: $showAlert)
//                .frame(width: 350, height: 60)
//                .cornerRadius(20)
//                .shadow(radius: 5)
            
            AppleAuth()
            
            if(isSignInPage) {
                signUpLinkSection
            } else {
                signInLinkSection
            }
        }.alert(isPresented: $showAlert) {
            Alert(
                title: Text("Account already exists"),
                message: Text("Sign in using a provider associated" +
                              " with this email address.")
            )
        }
    }
    
    public var loadingIndicator: some View {
        ZStack{
            if isLoading{
                Color.black
                    .opacity(0.25)
                    .ignoresSafeArea()
                
                ProgressView("Loading...")
                    .font(.title2)
                    .foregroundColor(.white)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
            }
        }
    }
    
    public var signUpLinkSection: some View {
        HStack{
            Text("Don't have an account?")
                .foregroundColor(Color.white)
            NavigationLink(destination: SignUpView()) {
                Text("Sign up")
            }
        }
    }
    
    public var signInLinkSection: some View {
        HStack{
            Text("Already have an account?")
                .foregroundColor(Color.white)
            NavigationLink(destination: SignInView()) {
                Text("Login Now")
            }
        }
    }
}

struct LogInItems_Previews: PreviewProvider {
    static var previews: some View {
        LogInItems(isSignInPage: true)
    }
}
