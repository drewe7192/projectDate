//
//  TitleView.swift
//  projectDate
//
//  Created by dotZ3R0 on 11/6/22.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        VStack{
            Top()
            Spacer()
                .frame(height: 150)
            
            Butttons()
        }
    }
}

struct Top: View{
    var body: some View{
        
        ZStack{
            Circle()
                .fill(.gray)
                .frame(width: 300, height: 300)
            
            LogoView()
        }
        Text("Welcome to thiss app blah blah blah fadsfs fadssf dsf dfs fds fds fds fdfs fdsfs fds fds fds")
            .font(.system(size: 30))
        
    }
}

struct Butttons: View{
    var body: some View{
        HStack{
            Button(action: {
            }) {
                Text("Sign In")
                    .bold()
                    .foregroundColor(Color.black)
                    .frame(width: 130, height: 50)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            
            Button(action: {
            }) {
                Text("Sign Up")
                    .bold()
                    .foregroundColor(Color.black)
                    .frame(width: 130, height: 50)
                    .background(Color.gray)
                    .cornerRadius(5)
            }
            
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
