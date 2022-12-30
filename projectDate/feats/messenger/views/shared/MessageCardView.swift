//
//  MessageCardView.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/25/22.
//

import SwiftUI

struct MessageCardView: View {
    var body: some View {
        ZStack{
            Text("")
                .font(.title.bold())
                .frame(width: 450, height: 80)
                .background(.white)
                .foregroundColor(.gray)
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 2))
            
            HStack{
                Image("animeGirl")
                    .resizable()
                .frame(width: 60, height: 60)
                .background(.gray)
                .clipShape(Circle())
                .padding(.trailing,30)
                
              
                
                VStack(alignment: .leading){
                    Text("Bob Barron")
                    Text("Yo that b was tripping bro")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct MessageCardView_Previews: PreviewProvider {
    static var previews: some View {
        MessageCardView()
    }
}
