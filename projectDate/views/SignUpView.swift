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
    @EnvironmentObject private var viewRouter: ViewRouter
    
    @State private var signInErrorMessage: String = ""
    @State private var email: String = ""
    @State private var password: String =  ""
    @State private var confirmPassword: String = ""
    @State private var displayConfirmPassword: Bool = true
    
    var body: some View {
        NavigationView {
            GeometryReader{ geoReader in
                ZStack{
                    // need a ZStack and color to change the background color
                    Color.mainBlack
                        .ignoresSafeArea()
                   
                    VStack{
                        headerSection(for: geoReader)
                        bodySection(for: geoReader)
                        footerSection(for: geoReader)
                     
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    
                    LogInItems(isSignInPage: false).loadingIndicator
                   
                }
                .position(x: geoReader.frame(in: .local).midX, y: geoReader.frame(in: .local).midY)
               
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func headerSection(for geoReader: GeometryProxy) -> some View {
        ZStack{
            Image("logo")
                .resizable()
                .frame(width: 70, height: 70)
                .background(Color.mainBlack)
                .position(x: geoReader.frame(in: .local).midX , y: geoReader.size.height * 0.04)
            
            VStack{
                Text("iceBreakrrr")
                    .font(.custom("Georgia-BoldItalic", size: geoReader.size.height * 0.04))
                    .bold()
                    .foregroundColor(Color.iceBreakrrrBlue)
                
                Text("break the ice")
                    .foregroundColor(.white)
                    .font(.system(size: geoReader.size.height * 0.02))
                    .multilineTextAlignment(.center)
                    .padding(.bottom,2)
                
//                Text("Create Account To get started now!")
//                    .foregroundColor(.white)
//                    .bold()
//                    .font(.system(size: geoReader.size.height * 0.03))
            }
            .position(x: geoReader.frame(in: .local).midX, y: geoReader.size.height * 0.12)
   
        }
    }
    
    private func bodySection(for geoReader: GeometryProxy) -> some View {
            VStack{
                EmailPasswordLoginView(email: $email, password: $password, confirmPassword: $confirmPassword, signInErrorMessage: $signInErrorMessage, displayConfirmPassword: $displayConfirmPassword)
                
                Text("Forgot Password?")
                    .padding(.leading, geoReader.size.height * 0.3)
                    .padding(.top,geoReader.size.height * 0.01)
                    .foregroundColor(.white)
            }
            .position(x: geoReader.frame(in: .local).midX, y: geoReader.size.height * 0.05)
        }
    }
    
    private func footerSection(for geoReader: GeometryProxy) -> some View {
        VStack{
            LogInItems(isSignInPage: false)
            
        }
        .position(x: geoReader.frame(in: .local).midX, y: geoReader.size.height * 0.15)
    }


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}


