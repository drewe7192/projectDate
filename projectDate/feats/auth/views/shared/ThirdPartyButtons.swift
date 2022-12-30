//
//  ThirdPartyButtons.swift
//  projectDate
//
//  Created by dotZ3R0 on 11/8/22.
//

import SwiftUI

struct ThirdPartyButtons: View{
    var body: some View{
        VStack{
            FacebookAuth()
            AppleAuth()
            GoogleAuth()
                .padding(.bottom,30)
        }
   
    }
}

struct ThirdPartyButtons_Previews: PreviewProvider {
    static var previews: some View {
        ThirdPartyButtons()
    }
}
