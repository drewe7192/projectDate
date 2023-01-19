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
                .frame(width: 370, height: 80)
                .background(Color.white)
                .foregroundColor(.white)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.blue, lineWidth: 2))
            
            VStack{
                HStack{
                    Image(systemName: "figure.australian.football")
                    Text("SpeedDating on Landis")
                }
                Text("August 10, 2010")
            }
        }    }
}

struct EventCardView_Previews: PreviewProvider {
    static var previews: some View {
        EventCardView()
    }
}
