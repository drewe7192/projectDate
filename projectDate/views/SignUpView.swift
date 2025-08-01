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
    @State private var signInErrorMessage: String = ""
    @State private var email: String = ""
    @State private var password: String =  ""
    
    @EnvironmentObject private var viewRouter: ViewRouter
    
    var body: some View {
        NavigationView {
            GeometryReader{ geoReader in
                ZStack{
                    Color.primaryColor
                        .ignoresSafeArea()
                    
                    VStack{
                        bodySection(for: geoReader)
                        footerSection(for: geoReader)
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func bodySection(for geoReader: GeometryProxy) -> some View {
        ZStack{
            CredentialFieldsView(email: $email, password: $password, isSignInView: false)
                .position(x: geoReader.frame(in: .local).midX, y: geoReader.frame(in: .local).midY)
            
            Text("littleBIGThings")
                .font(.custom("Noteworthy", size: geoReader.size.height * 0.07))
                .bold()
                .foregroundColor(.white)
                .position(x: geoReader.size.width * 0.5, y: geoReader.size.height * 0.25)
        }
    }
    
    private func footerSection(for geoReader: GeometryProxy) -> some View {
        HStack{
            Text("Already have an account?")
                .foregroundColor(Color.white)
            
            NavigationLink(destination: SignInView()) {
                Text("Log In now")
                    .foregroundColor(.blue)
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
