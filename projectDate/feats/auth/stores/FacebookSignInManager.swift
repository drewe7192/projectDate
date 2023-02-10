//
//  FacebookSignInManager.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/30/23.
//

import Foundation
import FBSDKLoginKit
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

//class FacebookSignInManager: ObservableObject {
//    @Published var isLoggedIn: Bool = false
//
//    @Published var mutlipleSignins: Bool = true
//
//    let loginManager = LoginManager()
//
//    // using a completion handler with a completion block to fire viewRouter AFTER this code completes
//    // also called a escaping closure
//    func facebookLogin(completion: @escaping (_ success: Bool) -> Void) {
//        loginManager.logIn(permissions: [.publicProfile, .email], viewController: nil) { loginResult in
//            switch loginResult {
//
//            case .failed(let error) :
//                print(error)
//                case .cancelled:
//                print("Usesr cancelled login.")
//
//            case .success(let grantedPermissions, let declinedPermissions, let accessToken) :
//                print("logged in! \(grantedPermissions) \(declinedPermissions) \(accessToken!)")
//                GraphRequest(graphPath: "me", parameters: ["fields" : "id, name, first_name"]).start(completionHandler: {(connection, result, error) -> Void in
//
//                    if (error == nil){
//                        let fbDetails = result as! NSDictionary
//                        print(fbDetails)
//                        self.isLoggedIn = true
//                        completion(true)
//                    }
//                })
//            }
//        }
//    }
//}


