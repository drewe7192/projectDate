//
//  FacebookAuth.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/11/22.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FacebookLogin

struct FacebookAuth: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var fbmanager = UserLoginManager()
    
    var body: some View {
        Button(action: {
            self.fbmanager.facebookLogin()
            }) {
            HStack(spacing: 15){
                Text("Sign in with Facebook")
                    .font(.title3)
                    .fontWeight(.medium)
                    .kerning(1.1)
            }
            .foregroundColor(Color.gray)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
            Capsule()
                .stroke(Color.black, lineWidth: 3)
            )
        }
        .frame(width: 350)
        .fullScreenCover(isPresented: self.$fbmanager.isLoggedIn) {
            HomeView()
        }
    }
}

class UserLoginManager: ObservableObject {
  
    @Published var isLoggedIn: Bool = false
  
    let loginManager = LoginManager()
    
    func facebookLogin() {
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: nil) { loginResult in
            switch loginResult {
                
            case .failed(let error) :
                print(error)
                case .cancelled:
                print("Usesr cancelled login.")
                
            case .success(let grantedPermissions, let declinedPermissions, let accessToken) :
                print("logged in! \(grantedPermissions) \(declinedPermissions) \(accessToken!)")
                GraphRequest(graphPath: "me", parameters: ["fields" : "id, name, first_name"]).start(completionHandler: {(connection, result, error) -> Void in
                    
                    if (error == nil){
                        let fbDetails = result as! NSDictionary
                        print(fbDetails)
                        self.isLoggedIn = true
                    }
                })
            }
        }
    }
}

struct FacebookAuth_Previews: PreviewProvider {
    static var previews: some View {
        FacebookAuth()
    }
}

