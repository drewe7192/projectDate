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
                AsyncImage(url: URL(string: "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg")) { image in
                    
                    image.resizable()
                } placeholder: {
                    
                }
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
