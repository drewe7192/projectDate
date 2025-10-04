//
//  ToastManager.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 10/3/25.
//

import SwiftUI

final class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var message: String = ""
    @Published var isShowing: Bool = false
    
    private var hideTask: Task<Void, Never>?
    
    @MainActor
    func showToast(_ message: String, duration: TimeInterval = 2.0) {
        hideTask?.cancel()
        self.message = message
        withAnimation { self.isShowing = true }
        
        hideTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            await MainActor.run {
                withAnimation { self?.isShowing = false }
            }
        }
    }
}

