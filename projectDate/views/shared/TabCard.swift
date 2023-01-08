//
//  TabCard.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/29/22.
//

import SwiftUI

struct TabCard: View {
    let item: ProfileModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            
            NavigationLink(destination: ProfileView(participant: item)) {
                Image("animeGirl")
                    .resizable()
            }
            .frame(width: 150, height: 200)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(30)
            .shadow(radius: 15, x: 1, y: 20)
            
            Text(item.fullName)
                .bold()
                .foregroundColor(.black)
            
            Text(item.location)
                .foregroundColor(.black)
        }
    }
}

struct TabCard_Previews: PreviewProvider {
    static var previews: some View {
        TabCard(item: MockService.profilesSampleData.first!)
    }
}
