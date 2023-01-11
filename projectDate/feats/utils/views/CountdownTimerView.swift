//
//  CountdownTimerView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/1/23.
//

import SwiftUI

struct CountdownTimerView: View {
    @StateObject var viewModel = sdViewModel()
    
    @State var timeRemaining = 0
    @State var isStartNow = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        sdHomeViewButton
    }
    
    var sdHomeViewButton: some View {
        Text(
            //just the display
            (isStartNow ? "Start Now!": "") +
            (isStartNow ? "" : displayCountdown()))
        //main logic for countdown
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else if timeRemaining == 0 {
                isStartNow = true
            }
        }
        //normal styling for button
        .multilineTextAlignment(.center)
        .font(.title.bold())
        .frame(width: 400, height: 70)
        .background(.white)
        .foregroundColor(.gray)
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 2)
        )
        
    }
    
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func displayCountdown() -> (String){
        var hours = secondsToHoursMinutesSeconds(timeRemaining).0
        var displayHours = "\(secondsToHoursMinutesSeconds(timeRemaining).0)" + "hrs "
        var displayMinutes = "\(secondsToHoursMinutesSeconds(timeRemaining).1)" + "mins "
        var displaySeconds = "\(secondsToHoursMinutesSeconds(timeRemaining).2)" + "secs "
        
        if(hours > 23){
            var displayDays = "\(hours / 24)" + (hours < 48 ? " day" : " days")
            return displayDays
        }
        return displayHours + displayMinutes + displaySeconds
    }
}

struct bar: View {
    var body: some View {
        Text("fdsf")
    }
}

struct CountdownTimerView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownTimerView(timeRemaining: 80400)
    }
}
