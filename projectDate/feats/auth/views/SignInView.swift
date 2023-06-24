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
                    LogInItems(isSignInPage: true).loadingIndicator
                }
                .position(x: geoReader.frame(in: .local).midX, y: geoReader.frame(in: .local).midY)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func bodySection(for geoReader: GeometryProxy) -> some View {
        ZStack{
            Image("logo")
                .resizable()
                .frame(width: 100, height: 100)
                .background(Color.mainBlack)
                .position(x: geoReader.frame(in: .local).midX, y: geoReader.size.height * 0.1)
            
            VStack{
                Text("iceBreakrrr")
                    .font(.custom("Georgia-BoldItalic", size: geoReader.size.height * 0.07))
                    .bold()
                    .foregroundColor(Color.iceBreakrrrBlue)
                
                Text("Break the Ice")
                    .foregroundColor(.white)
                    .font(.system(size: geoReader.size.height * 0.02))
                    .multilineTextAlignment(.center)
            }
            .position(x: geoReader.frame(in: .local).midX, y: geoReader.size.height * 0.17)
            
            VStack{
                EmailPasswordLoginView(email: $email, password: $password,confirmPassword: $confirmPassword, signInErrorMessage: $signInErrorMessage, displayConfirmPassword: $displayConfirmPassword)
                
                Text("Forgot Password?")
                    .padding(.leading, geoReader.size.height * 0.3)
                    .padding(.top,geoReader.size.height * 0.01)
                    .foregroundColor(.white)
            }
            .position(x: geoReader.frame(in: .local).midX, y: geoReader.size.height * 0.42)
        }
    }
    
    private func footerSection(for geoReader: GeometryProxy) -> some View{
        VStack{
            LogInItems(isSignInPage: true)
        }
        .position(x: geoReader.frame(in: .local).midX, y: geoReader.size.height * 0.3)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}




