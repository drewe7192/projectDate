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
                Image(participant.images.first!)
                    .resizable()
                    .scaledToFill()
                .frame(width: 90, height: 80)
                .background(.gray)
                .clipShape(Rectangle())
                .cornerRadius(40)
    
        }
    }
}

struct sdCardView_Previews: PreviewProvider {
    static var previews: some View {
        sdCardView(participant: MockService.profileSampleData)
    }
}
