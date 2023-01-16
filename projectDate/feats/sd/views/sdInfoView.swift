//
//  sdInfoView.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/25/22.
//

import SwiftUI

struct sdInfoView: View {
    var body: some View {
        ZStack{
            Color("Grey")
                .ignoresSafeArea()
            VStack{
                Text("sdInfo")
                    .font(.system(size: 70, weight: .bold))
                
                Text("Dating Order")
                    .font(.system(size: 40, weight: .medium))
                
                ImageGridView()
                
                VStack{
                    
                    Text("Fun Facts")
                        .font(.system(size: 40, weight: .medium))
                    
                    ForEach(0..<3){item in
                        
                        ZStack{
                            Text("")
                                .font(.title.bold())
                                .frame(width: 400, height: 80)
                                .background(.white)
                                .foregroundColor(.gray)
                                .cornerRadius(20)
                                .overlay(RoundedRectangle(cornerRadius: 20)
                                    .stroke(.black, lineWidth: 2))
                            
                            HStack{
                                Image("animeGirl")
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 60, height: 60)
                                
                                Text("I like kittens")
                                
                            }
                        }
                    }
              
             
            
                }
            }
        }
        
    }
}

struct sdInfoView_Previews: PreviewProvider {
    static var previews: some View {
        sdInfoView()
    }
}
