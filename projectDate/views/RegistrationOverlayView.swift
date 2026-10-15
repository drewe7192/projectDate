//
//  RegistrationOverlayView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 10/15/26.
//

import SwiftUI

struct RegistrationOverlayView: View {
    var body: some View {
        VStack(spacing: 24) {
            
            // 1. The Core Messaging
            VStack(spacing: 12) {
                Text("Ready to jump in the HotSeat?")
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                
                Text("Live alpha events require registration. To get your profile added to the next round, connect with us below:")
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            // 2. The Direct Action Buttons
            VStack(spacing: 14) {
                
                // Direct Tap-to-Email Link styled like a premium button
                Link(destination: URL(string: "mailto:joinhotseatapp@://gmail.com")!) {
                    HStack(spacing: 10) {
                        Image(systemName: "envelope.fill")
                        Text("Email: joinhotseatapp@gmail.com")
                    }
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(12)
                    .shadow(color: .blue.opacity(0.3), radius: 6, x: 0, y: 3)
                }
                
                // Professional Developer Connection Link
                Link(destination: URL(string: "https://linkedin.com")!) {
                    HStack(spacing: 10) {
                        Image(systemName: "person.crop.circle.badge.plus")
                        Text("Message Main Developer Directly")
                    }
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.gray.opacity(0.3)) // Subdued secondary style
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white.opacity(0.4), lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, 24)
        }
        .padding(.vertical, 32)
        .background(Color.black.opacity(0.85)) // Dark UI canvas baseline
        .cornerRadius(20)
        .padding(.horizontal, 16)
    }
}


#Preview {
    RegistrationOverlayView()
}
