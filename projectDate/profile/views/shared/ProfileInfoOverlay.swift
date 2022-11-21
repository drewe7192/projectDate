//
//  ProfileInfoOverlay.swift
//  projectDate
//
//  Created by Drew Sutherland on 11/21/22.
//

import SwiftUI

struct ProfileInfoOverlay: View {
    var body: some View {
        ZStack{
            Spacer()
            VStack{

            }
            .frame(width: 300, height: 200)
            .background(.gray)
            .cornerRadius(20)
            .opacity(0.5)
            
        }
    }
}



struct ProfileInfoOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInfoOverlay()
    }
}
