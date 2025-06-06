//
//  AppleAuth.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/7/22.
//

import SwiftUI
import AuthenticationServices
import CryptoKit
import FirebaseAuth

struct AppleAuth: View {
    @State var currentNonce: String?
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach{ random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        SignInWithAppleButton(
            onRequest: { request in
                let nonce = randomNonceString()
                currentNonce = nonce
                request.requestedScopes = [.fullName, .email]
                request.nonce = sha256(nonce)
            },
            onCompletion: { result in
                switch result {
                case .success (let authResults):
                    switch authResults.credential {
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        
                        guard let nonce = currentNonce else {
                            fatalError("Invalid state: A login callback was received, but no login request was sent.")
                        }
                        guard let appleIDToken = appleIDCredential.identityToken else {
                            fatalError("Invalid state: A login callback was received, but no login request was sent.")
                        }
                        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                            return
                        }
                        
                        let credential = OAuthProvider.credential(withProviderID: "apple.com" ,idToken: idTokenString, rawNonce: nonce)
                        
                        Auth.auth().signIn(with: credential) { (authResult, error) in
                            if(error != nil) {
                                print(error?.localizedDescription as Any)
                                return
                            }
                            print("signed in")
                            
                            viewRouter.currentPage = .homePage
                        }
                    default:
                        break
                    }
                default:
                    break
                }
            }
        )
        .frame(width: 350, height: 60)
        .cornerRadius(20)
        .shadow(radius: 5)
        
    }
}

struct AppleAuth_Previews: PreviewProvider {
    static var previews: some View {
        AppleAuth()
    }
}
