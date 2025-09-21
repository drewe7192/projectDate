//
//  GlassInputField.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 9/1/25.
//

import SwiftUI

struct GlassInputField: View {
    var placeholder: String
    @Binding var text: String
    var isFocused: Bool
    
    var body: some View {
        TextField(placeholder, text: $text)
            .foregroundStyle(.white)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.cyan.opacity(isFocused ? 0.7 : 0.3), lineWidth: 1)
                    .shadow(color: Color.cyan.opacity(isFocused ? 0.5 : 0), radius: isFocused ? 8 : 0)
            )
            .animation(.easeInOut(duration: 0.3), value: isFocused)
    }
}

#Preview {
    GlassInputField(placeholder: "Test", text: .constant(""), isFocused: false)
}
