//
//  EventCardView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import SwiftUI

struct EventCardView: View {
    let event: EventModel
    
    var body: some View {
        ZStack{
            
            Color(.systemTeal)
                .ignoresSafeArea()
            
            Text("")
                .frame(width: 370, height: 100)
                .cornerRadius(60)
                .shadow(radius: 10)
                .overlay(RoundedRectangle(cornerRadius: 60).stroke(.white, lineWidth: 6))
            
            VStack{
                VStack(alignment: .leading){
                    Text("\(event.title)")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                    
                    VStack{
                        Text("\(event.location)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        
                        Text("\(event.eventDate)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                }
                .padding(.trailing,70)
            }
            
            HStack{
                ForEach(event.participants, id: \.?.id){ item in
                    Image("animeGirl")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                }
            }
            .padding(.leading,240)
            .padding(.top,40)
        }
    }
}

struct EventCardView_Previews: PreviewProvider {
    static var previews: some View {
        EventCardView(event: MockService.eventsSampleData.first!)
    }
}
