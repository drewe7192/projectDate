//
//  ImageDetailView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/8/23.
//

import SwiftUI

struct ImageDetailView: View {
    let image: String
    
    var body: some View {
       Image(image)
            .resizable()
            .scaledToFit()
    }
}

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetailView(image: "animeGirl")
    }
}
