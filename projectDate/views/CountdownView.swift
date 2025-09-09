//
//  CountdownView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 9/8/25.
//

import SwiftUI
import Combine

struct CountdownView: View {
    let targetDate: Date
    
    @State private var timeRemaining: String = ""
    
    // Timer publisher fires every second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text(timeRemaining)
            .font(.title)
            .onAppear {
                updateTimeRemaining()
            }
            .onReceive(timer) { _ in
                updateTimeRemaining()
            }
    }
    
    func updateTimeRemaining() {
        let now = Date()
        let diff = targetDate.timeIntervalSince(now)
        
        if diff <= 0 {
            timeRemaining = "Time's up!"
        } else {
            let days = Int(diff) / (24 * 3600)
            let hours = (Int(diff) % (24 * 3600)) / 3600
            let minutes = (Int(diff) % 3600) / 60
            let seconds = Int(diff) % 60
            timeRemaining = String(format: "%02dd %02dh %02dm %02ds", days, hours, minutes, seconds)
        }
    }
}
