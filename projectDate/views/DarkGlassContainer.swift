//
//  DarkGlassContainer.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 9/1/25.
//

import SwiftUI

struct DarkGlassContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 20) {
            content
        }
        .padding(25)
        .background(
            ZStack {
                // Dark translucent background
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.black.opacity(0.3))
                
                // Subtle blur to mimic glass
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white.opacity(0.03))
                    .blur(radius: 8)
                
                // Thin neon border
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
            }
        )
        .shadow(color: Color.black.opacity(0.6), radius: 15, x: 0, y: 5)
    }
}
