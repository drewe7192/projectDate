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
                .frame(height: 100)
            
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
        .padding(.bottom, 30)
        
        VStack(spacing: 20){
            Text("Discover your" + "\n" + "New MATCH here")
                .font(.title.bold())
                .multilineTextAlignment(.center)
            
            Text("Bringing a new way to date combined with the classical way blah blah blah")
                .font(.title2)
                .multilineTextAlignment(.center)
        }

  
        
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
                    .frame(width: 130, height: 60)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            
            Button(action: {
            }) {
                Text("Sign Up")
                    .bold()
                    .foregroundColor(Color.black)
                    .frame(width: 130, height: 60)
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
