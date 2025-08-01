//
//  AnimatedButton.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 5/5/25.
//

import SwiftUI

struct AnimatedButton: View {
    var config: Config
    var shape: AnyShape = .init(.capsule)
    var onTap: () async -> ()
    // View Properties
    @State private var isLoading: Bool = false
    var body: some View {
        Button {
            Task {
                isLoading = true
                await onTap()
                isLoading = false
            }
        } label: {
            HStack {
                if let symbolImage = config.symbolImage {
                    Image(systemName: symbolImage)
                        .font(.title3)
                        .transition(.blurReplace)
                } else {
                    if isLoading {
                        Spinner(tint: config.foregroundColor, lineWidth: 4)
                            .frame(width: 20, height: 20)
                            .transition(.blurReplace)
                    }
                }
                
                Text(config.title)
                    .font(.system(size: 20))
                    .frame(width: 300, height: 50)
                    .contentTransition(.interpolate)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
            }
            .padding(.horizontal, config.hPadding)
            .padding(.vertical, config.vPadding)
            .foregroundStyle(config.foregroundColor)
            .background(config.background.gradient)
            .clipShape(shape)
            .contentShape(shape)
        }
        /// Disabling Button when Task is Performing
        .disabled(isLoading)
        /// custom button style which uses scale animation rather than default opacity animation
        .buttonStyle(ScaleButtonStyle())
        .animation(config.animation, value: config)
        .animation(config.animation, value: isLoading)
    }
    
    struct Config: Equatable {
        var title: String
        var foregroundColor: Color
        var background: Color
        var symbolImage: String?
        var hPadding: CGFloat = 15
        var vPadding: CGFloat = 10
        var animation: Animation = .easeInOut(duration: 0.25)
    }
}

fileprivate struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .animation(.linear(duration: 0.2)) {
                $0
                    .scaleEffect(configuration.isPressed ? 0.9 : 1)
            }
    }
}

#Preview {
    FullScreenComponentsView(isMicMuted: .constant(false), role: RoleType.host)
        .environmentObject(VideoViewModel())
        .environmentObject(QAViewModel())
        .environmentObject(AppDelegate())
        .environmentObject(ProfileViewModel())
}
