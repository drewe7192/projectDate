//
//  ImageSlider.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/21/22.
//

import SwiftUI

struct ImageSlider: View {
    let person: ProfileModel

    var body: some View {
        TabView{
                ForEach(person.images, id: \.self) {item in
                    Image(item)
                        .resizable()
                }
                .ignoresSafeArea()
       
        }
        .ignoresSafeArea()
        .tabViewStyle(PageTabViewStyle())
    }
}

struct ImageSlider_Previews: PreviewProvider {
    static var previews: some View {
        ImageSlider(person: MockService.profileSampleData)
            .previewLayout(.fixed(width: 400, height: 300))
    }
}
