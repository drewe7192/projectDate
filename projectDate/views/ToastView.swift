//
//  ToastView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 10/3/25.
//

import SwiftUI

struct ToastView: View {
    @ObservedObject var toastManager: ToastManager = .shared
    @EnvironmentObject var qaViewModel: QAViewModel
    
    var body: some View {
        VStack {
            Spacer()
            if toastManager.isShowing {
                Text(toastManager.message)
                    .frame(width: 300, height: 80)
                    .font(.system(size: 25))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(qaViewModel.currentQAWidgetState == .BCRequestSent ? Color.green.opacity(0.75) : Color.black.opacity(0.75))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.bottom, 40)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .animation(.easeInOut, value: toastManager.isShowing)
        .allowsHitTesting(false) // so it doesn't block taps
    }
}

#Preview {
    ToastView()
        .environmentObject(QAViewModel())
}

