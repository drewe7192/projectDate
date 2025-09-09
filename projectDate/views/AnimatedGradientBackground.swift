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
        let screen = UIScreen.main.bounds
        let extra: CGFloat = 2.0

        LinearGradient(
            gradient: Gradient(colors: [
                Color(red:0.09, green:0.00, blue:0.30),
                Color(red:0.05, green:0.05, blue:0.1),
                Color(red:0.07, green:0.03, blue:0.12),
                Color(red:0.09, green:0.00, blue:0.30)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .frame(width: screen.width * extra, height: screen.height * extra)
        .position(x: screen.width / 2, y: screen.height / 2)
        .offset(
            x: animate ? -screen.width * 0.5 : screen.width * 0.5,
            y: animate ? -screen.height * 0.5 : screen.height * 0.5
        )
        .ignoresSafeArea()
        .onAppear { animate = true }
        .animation(
            .linear(duration: 4).repeatForever(autoreverses: true),
            value: animate
        )
    }
}

