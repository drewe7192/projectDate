//
//  SignUpView.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/4/22.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFunctions

struct SignUpView: View {
    @State private var signInErrorMessage: String = ""
    @State private var email: String = ""
    @State private var password: String =  ""
    @State private var isButtonPressed: Bool = false
    @FocusState private var focusedField: Field?
    @State var errorMessage: String = ""
    @State private var roomCode: String?
    @State private var isCreatingUser: Bool = false
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    enum Field {
        case email, password
    }
    
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
                        if (isCreatingUser) {
                            ProgressView()
                                .scaleEffect(1.5, anchor: .center)
                        } else {
                            // Sign Up Button
                            Button(action: {
                                Task {
                                    isButtonPressed.toggle()
                                    await createUser()
                                }
                            }) {
                                Text("Sign Up")
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
                                    .scaleEffect(isButtonPressed ? 1.05 : 1.0)
                                    .animation(.easeInOut(duration: 0.15), value: isButtonPressed)
                            }
                            .padding(.horizontal, 30)
                        }
                        
                        
                        footerSection(for: geoReader)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func createUser() async {
        do {
            isCreatingUser.toggle()
            let newRoomCode = try await handleSignupAndRoomCreation(email: email, password: password)
            profileViewModel.newRoomCode = newRoomCode
            viewRouter.currentPage = .walkThroughPage
            isCreatingUser.toggle()
        } catch {
            self.errorMessage = error.localizedDescription
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
    
    // This function can be part of your ViewModel or a utility class
    func handleSignupAndRoomCreation(email: String, password: String) async throws -> String {
        // 1. Create the user. This also signs them in.
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        
        // 2. Explicitly fetch the ID token for the newly created user.
        let _ = try await authResult.user.idTokenForcingRefresh(true)
        
        // 3. Call the Firebase Cloud Function securely.
        let functions = Functions.functions()
        let result = try await functions.httpsCallable("createRoom").call()
        
        guard let responseData = result.data as? [String: Any],
              let roomCode = responseData["roomCode"] as? String else {
            throw NSError(domain: "FunctionsError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from Cloud Function"])
        }
        return roomCode
    }
}

#Preview {
    SignUpView()
        .environmentObject(ProfileViewModel())
}
