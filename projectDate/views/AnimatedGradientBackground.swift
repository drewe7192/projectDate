//
//  AnimatedGradientBackground.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 9/1/25.
//

import SwiftUI

struct AnimatedGradientBackground: View {
    @State private var animate = false
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(#colorLiteral(red:0.02, green:0.02, blue:0.05, alpha:1)),
                Color(#colorLiteral(red:0.05, green:0.05, blue:0.1, alpha:1)),
                Color(#colorLiteral(red:0.07, green:0.03, blue:0.12, alpha:1))
            ]),
            startPoint: animate ? .topLeading : .bottomTrailing,
            endPoint: animate ? .bottomTrailing : .topLeading
        )
        .animation(
            Animation.linear(duration: 20)
                .repeatForever(autoreverses: true),
            value: animate
        )
        .onAppear { animate = true }
    }
}
