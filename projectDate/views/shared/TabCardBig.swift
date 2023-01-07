//
//  TabCardBig.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/7/23.
//

import SwiftUI

struct TabCardBig: View {
    let item: ProfileModel
    
    var body: some View {
            VStack{
                NavigationLink(destination: ProfileView(participant: MockService.profileSampleData)) {
                    Image("animeGirl")
                        .resizable()
                    
                }
                .frame(width: 300, height: 300)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(30)
                
                Text(item.fullName)
                    .bold()
                
                Text(item.location)
            }
    }
}

struct TabCardBig_Previews: PreviewProvider {
    static var previews: some View {
        TabCardBig(item: MockService.profileSampleData)
    }
}
