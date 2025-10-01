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
    @State private var signInErrorMessage: String = ""
    @State var errorMessage: String = ""
    @State private var email: String = ""
    @State private var password: String =  ""
    @State private var isButtonPressed: Bool = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    @EnvironmentObject private var viewRouter: ViewRouter
    
    var body: some View {
        NavigationView {
            GeometryReader { geoReader in
                ZStack {
                    AnimatedGradientBackground()
                        .ignoresSafeArea()
                    
                    NeonParticlesView(count: 30, color: .cyan.opacity(0.8))
                    
                    VStack(spacing: 30) {
                        Text("littleBIGThings")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .cyan.opacity(0.5), radius: 12, x: 0, y: 0)
                        
                        DarkGlassContainer {
                            GlassInputField(placeholder: "Email", text: $email, isFocused: focusedField == .email)
                                .focused($focusedField, equals: .email)
                            GlassSecureField(placeholder: "Password", text: $password, isFocused: focusedField == .password)
                                .focused($focusedField, equals: .password)
                        }
                        .padding(.horizontal, 30)
                        
                        // Sign In Button
                        Button(action: {
                            isButtonPressed.toggle()
                            signInUser()
                        }) {
                            Text("Sign In")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.cyan.opacity(0.4), lineWidth: 1)
                                )
                                .cornerRadius(12)
                                .shadow(color: Color.cyan.opacity(0.3), radius: 8, x: 0, y: 4)
                                .scaleEffect(isButtonPressed ? 1.03 : 1.0)
                                .animation(.easeInOut(duration: 0.15), value: isButtonPressed)
                        }
                        .padding(.horizontal, 30)
                        .disabled(!email.isEmpty && !password.isEmpty ? false : true)
                        .opacity(!email.isEmpty && !password.isEmpty ? 1 : 0.5)
                        
                        footerSection(for: geoReader)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func footerSection(for geoReader: GeometryProxy) -> some View {
        HStack{
            Text("Don't have an account?")
                .foregroundColor(Color.white)
            
            NavigationLink(destination: SignUpView()) {
                Text("Sign up")
                    .foregroundColor(.blue)
            }
        }
    }
    
    private func signInUser(){
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard error ==  nil else{
                self.errorMessage = error!.localizedDescription
                return
            }
            switch authResult {
            case .none:
                print("Cound not sign in user.")
            case .some(_):
                print("User signed in")
                viewRouter.currentPage = .homePage
            }
        }
    }
}

#Preview {
    SignInView()
}
