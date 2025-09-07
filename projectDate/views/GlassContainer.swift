import SwiftUI

struct GlassContainer<Content: View>: View {
    let cornerRadius: CGFloat
    let content: Content
    
    init(cornerRadius: CGFloat = 16,
         @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Transparent background with subtle tint
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.08),
                            Color.white.opacity(0.02)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .background(
                    Color.white.opacity(0.01) // faint backing for visibility
                )
                .overlay(
                    // Glossy stroke
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
            
            // Content
            content
                .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

