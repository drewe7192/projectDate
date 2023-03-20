//
//  CredentialFieldsView.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/19/23.
//

import SwiftUI

struct CredentialFieldsView: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @Binding var displayConfirmPassword: Bool
    
    var body: some View {
        ZStack{
            // Use this color to help see the fields better in preview
//            Color(.systemPink)
//                .ignoresSafeArea()
            
            Group{
                VStack{
                    ZStack{
                        // using 2 text fields to get the proper effect I want:
                        // a faded background inside textField but text is still bold
                        //and visible
                        TextField("", text: $email)
                            .foregroundColor(.black)
                            .frame(width: 340, height: 25)
                            .padding()
                            .background(.white)
                            .opacity(0.3)
                            .cornerRadius(10)
                            .textInputAutocapitalization(.never)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
                            )
                            .padding(.bottom,3)
                        
                        TextField("Email", text: $email)
                            .foregroundColor(.white)
                            .frame(width: 340, height: 25)
                            .padding()
                            .cornerRadius(10)
                            .textInputAutocapitalization(.never)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
                            )
                            .padding(.bottom,3)
                    }
                    
                    ZStack{
                        // using 2 text fields to get the proper effect I want:
                        // a faded background inside textField but text is still bold
                        //and visible
                        SecureField("", text: $password)
                            .frame(width: 340, height: 25)
                            .padding()
                            .background(.white)
                            .opacity(0.3)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
                            )
                        
                        SecureField("Password", text: $password)
                            .frame(width: 340, height: 25)
                            .padding()
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
                            )
                    }
                    
                    if(displayConfirmPassword){
                        ZStack{
                            SecureField("Confirm Password", text: $confirmPassword)
                                .frame(width: 340, height: 25)
                                .padding()
                                .background(.white)
                                .opacity(0.3)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
                                )

                            SecureField("Confirm Password", text: $confirmPassword)
                                .frame(width: 340, height: 25)
                                .padding()
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
                                )
                        }
                    }
                }
            }
        }
    }
}

struct CredentialFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        CredentialFieldsView(email: .constant(""), password: .constant(""), confirmPassword: .constant(""),displayConfirmPassword: .constant(true))
    }
}
