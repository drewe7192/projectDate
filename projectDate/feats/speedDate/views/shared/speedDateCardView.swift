//
//  speedDateCardView.swift
//  projectDate
//
//  Created by DotZ3R0 on 4/4/23.
//

import SwiftUI

struct SpeedDateCardView: View {
    let participant: ProfileModel
    
    var body: some View {
        ZStack{
//                Image(participant.images.first!)
//                    .resizable()
//                    .scaledToFill()
//                .frame(width: 90, height: 80)
//                .background(.gray)
//                .clipShape(Rectangle())
//                .cornerRadius(40)
//
        }
    }
}

struct SpeedDateCardView_Previews: PreviewProvider {
    static var previews: some View {
        SpeedDateCardView(participant: MockService.profileSampleData)
    }
}

