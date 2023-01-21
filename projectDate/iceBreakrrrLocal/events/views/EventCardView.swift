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
                    Text("")
                        .frame(width: 370, height: 130)
                        .background(Color.white)
                        .foregroundColor(.white)
                        .cornerRadius(60)
                        .shadow(radius: 10)

                    VStack{
                        VStack(alignment: .leading){
                            Text("SpeedDate Kickball")
                                .foregroundColor(.black)
                                .font(.system(size: 25))
                                .padding(.top,2)

                            Text("Wharf Tampa")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                                .padding(.bottom,2)
                            
                            Text("9/23")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                        }
                        .padding(.trailing,70)
                        }
                    .padding(.bottom,30)
            
            HStack{
                ForEach(0..<4){ item in
                    Text("AV")
                        .foregroundColor(.black)
                        .frame(width: 40, height: 40)
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                }
            }.padding(.leading,80)
            .padding(.top,70)
                        
                }
    }
}

struct EventCardView_Previews: PreviewProvider {
    static var previews: some View {
        EventCardView()
    }
}
