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
                    NavigationLink(destination: ImageDetailView(image: item), label: {
                        Image(item)
                            .resizable()
                            .scaledToFill()
                    })
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
         
    }
}
