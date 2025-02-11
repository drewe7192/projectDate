//
//  EditProfile.swift
//  DatingApp
//
//  Created by DotZ3R0 on 7/28/22.
//

import SwiftUI

struct EditProfileView: View {
    @State private var userName: String = ""
    
    var body: some View {
        VStack{         
            Form {
                Section{
                    Text("My Photos(image grid section)")
                    Text("About Me")
                        .font(.subheadline)
                    TextField("about me", text: $userName)
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 300, height: 40)
                }
                Section{
                    Text("Interests")
                        .font(.subheadline)
                    TextField("interests", text: $userName)
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 300, height: 40)
                }
                Section{
                    Text("Job Title")
                        .font(.subheadline)
                    TextField("Job Title", text: $userName)
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 300, height: 40)
                }
                
                Section{
                    Text("School")
                        .font(.subheadline)
                    TextField("School", text: $userName)
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 300, height: 40)
                }
                Section{
                    
                    Text("Gender")
                        .font(.subheadline)
                    TextField("Straight", text: $userName)
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                }
                Section{
                    Text("Sexual Orientation")
                        .font(.subheadline)
                    TextField("Gender", text: $userName)
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                }
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
