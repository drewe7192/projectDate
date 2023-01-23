//
//  EventCardView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import SwiftUI

struct EventCardView: View {
    var body: some View {
        ZStack{
            
            Color("IceBreakrrrBlue")
                .ignoresSafeArea()
            
            Text("")
                .frame(width: 370, height: 100)
                .cornerRadius(60)
                .shadow(radius: 10)
                .overlay(RoundedRectangle(cornerRadius: 60).stroke(.white, lineWidth: 6))
            
            VStack{
                VStack(alignment: .leading){
                    Text("SpeedDate Kickball")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                    
                    VStack{
                        Text("Wharf Tampa")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        
                        Text("9/23")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                }
                .padding(.trailing,70)
            }
            
            HStack{
                ForEach(0..<4){ item in
                    Image("animeGirl")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                }
            }
            .padding(.leading,120)
            .padding(.top,40)
        }
    }
}

struct EventCardView_Previews: PreviewProvider {
    static var previews: some View {
        EventCardView()
    }
}
