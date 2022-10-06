//
//  LogoView.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/17/22.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        Image("sasuke")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: 150)
            .padding(.top, 70)
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
