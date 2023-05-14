//
//  MenuView.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/17/23.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image(systemName: "person")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Profile")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top,100)
            
            HStack{
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Messages")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top,100)
            
            HStack{
                Image(systemName: "gear")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Settings")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top,100)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 32/255, green: 32/255, blue: 32/255))
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
