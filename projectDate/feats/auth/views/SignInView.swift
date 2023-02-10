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
    @ObservedObject var fbmanager = FacebookSignInManager()
    
    @State var signInErrorMessage = ""
    @State var email = ""
    @State var password =  ""
    @State var isLoggedIn: Bool = false
    @State var signInProcessing = false
    @State var toggleButons = false

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
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private var headerSection: some View {
        VStack{
            VStack{
                Text("Welcome,")
                    .foregroundColor(.white)
                    .bold()
                    .font(.system(size: 30))
                
                Text("Glad to see you!")
                    .foregroundColor(.white)
                    .font(.system(size: 30))
            }
            EmailPasswordLogIn(email: $email, password: $password, signInProcessing: $signInProcessing, signInErrorMessage: $signInErrorMessage, isLoggedIn: $isLoggedIn)
            
            Text("Forgot Password?")
                .padding(.leading, 230)
                .padding(.top,10)
                .foregroundColor(.white)
            
        }
        .padding(.bottom,80)
    }
    
    private var bodySection: some View {
        VStack{
            Text("or Login with")
                .foregroundColor(.white)
                .padding(.bottom,20)
            
          LogInItems()
            
            LogInItems().signUpLinkSection
                .padding(.bottom,80)
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




