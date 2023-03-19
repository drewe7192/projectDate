//
//  SignInView.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/4/22.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct SignInView: View {
    @EnvironmentObject private var viewRouter: ViewRouter
    
    @State private var signInErrorMessage: String = ""
    @State private var email: String = ""
    @State private var password: String =  ""
    @State private var confirmPassword: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var displayConfirmPassword: Bool = false
    
    var body: some View {
        NavigationView {
            GeometryReader{ geoReader in
                ZStack{
                    // need a ZStack and color to change the background color
                    Color.mainBlack
                        .ignoresSafeArea()
                    
                    VStack{
                        bodySection(for: geoReader)
                        footerSection(for: geoReader)
                    }
                    LogInItems().loadingIndicator
                }
            }
           
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func bodySection(for geoReader: GeometryProxy) -> some View {
        VStack{
            VStack{
                Text("iceBreakrrr")
                    .font(.custom("Georgia-BoldItalic", size: geoReader.size.height * 0.07))
                    .bold()
                    .foregroundColor(Color.iceBreakrrrBlue)
                
                Text("Relationship app where you're the matchmaker!")
                    .foregroundColor(.white)
                    .font(.system(size: geoReader.size.height * 0.02))
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom,geoReader.size.height * 0.02)
            
            EmailPasswordLoginView(email: $email, password: $password,confirmPassword: $confirmPassword, signInErrorMessage: $signInErrorMessage, displayConfirmPassword: $displayConfirmPassword)
            
            Text("Forgot Password?")
                .padding(.leading, geoReader.size.height * 0.3)
                .padding(.top,geoReader.size.height * 0.01)
                .foregroundColor(.white)
        }
    }
    
    private func footerSection(for geoReader: GeometryProxy) -> some View{
        VStack{
            Text("or Login with")
                .foregroundColor(.white)
                .padding(.top,geoReader.size.height * 0.08)
            
            LogInItems()
            LogInItems().signUpLinkSection
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
            SignInView()
    }
}




