//
//  NeonParticlesView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 9/1/25.
//

import SwiftUI

struct NeonParticlesView: View {
    let count: Int
    var color: Color = .cyan.opacity(0.7)
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<count, id: \.self) { i in
                // Random size for each particle
                let size = CGFloat.random(in: 4...100)
                
                // Random base position
                let baseX = CGFloat.random(in: 0...UIScreen.main.bounds.width)
                let baseY = CGFloat.random(in: 0...UIScreen.main.bounds.height)
                
                Circle()
                    .fill(color)
                    .frame(width: size, height: size)
                    .position(
                        x: baseX + (animate ? CGFloat.random(in: -15...15) : 0),
                        y: baseY + (animate ? CGFloat.random(in: -15...15) : 0)
                    )
                    .blur(radius: CGFloat.random(in: 5...15))
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 3...8))
                            .repeatForever(autoreverses: true),
                        value: animate
                    )
            }
        }
        .onAppear { animate = true }
    }
}

#Preview {
    ContentView()
}
