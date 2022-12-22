//
//  ImageSlider.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/21/22.
//

import SwiftUI

struct ImageSlider: View {
    
    private let images = ["animeGirl","animeGirl2","sasuke"]
    
    var body: some View {
        TabView{
            ForEach(images, id: \.self) {item in
                Image(item)
                    .resizable()
                    .scaledToFill()
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct ImageSlider_Previews: PreviewProvider {
    static var previews: some View {
        ImageSlider()
            .previewLayout(.fixed(width: 400, height: 300))
    }
}
