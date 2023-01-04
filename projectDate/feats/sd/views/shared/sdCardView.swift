//
//  sdCardView.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/2/22.
//

import SwiftUI

struct sdCardView: View {
    let participant: ProfileModel
    
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
                Image(participant.images.first!)
                    .resizable()
                .frame(width: 60, height: 60)
                .background(.gray)
                .clipShape(Circle())
                
                VStack{
                    Text(participant.fullName)
                    Text(participant.location)
                }
            }
        }
    }
}

struct sdCardView_Previews: PreviewProvider {
    static var previews: some View {
        sdCardView(participant: MockService.profileSampleData)
    }
}
