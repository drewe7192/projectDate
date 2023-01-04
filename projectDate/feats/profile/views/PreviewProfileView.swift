//
//  PreviewProfileView.swift
//  DatingApp
//
//  Created by DotZ3R0 on 7/30/22.
//

import SwiftUI

struct PreviewProfileView: View {
    var body: some View {
       ProfileView(participant: MockService.profileSampleData)
    }
}

struct PreviewProfileView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewProfileView()
    }
}
