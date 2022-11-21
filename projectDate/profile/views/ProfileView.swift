//
//  UserProfileView.swift
//  projectDate
//
//  Created by Drew Sutherland on 11/21/22.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack{
            AsyncImage(url: URL(string: "https://i.pinimg.com/originals/01/c6/f4/01c6f460f860a0c5d6a6c22d01716951.jpg")) { image in
                image.resizable()
                    .overlay(ProfileInfoOverlay())
            } placeholder: {
                ProgressView()
            }
            .frame(width: .infinity, height: 900)
            .background(Color.gray)
            .clipShape(Rectangle())
            
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
        }
    
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
