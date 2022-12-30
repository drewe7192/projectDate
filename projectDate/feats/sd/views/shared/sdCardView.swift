//
//  sdCardView.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/2/22.
//

import SwiftUI

struct sdCardView: View {
    var body: some View {
        ZStack{
            Text("")
                .font(.title.bold())
                .frame(width: 350, height: 80)
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
                
                VStack{
                    Text("Emily Barron")
                    Text("Tampa,FL")
                }
            }
        }
    }
}

struct sdCardView_Previews: PreviewProvider {
    static var previews: some View {
        sdCardView()
    }
}
