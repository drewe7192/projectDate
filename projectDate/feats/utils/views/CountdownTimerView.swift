//
//  CountdownTimerView.swift
//  projectDate
//
//  Created by DotZ3R0 on 4/4/23.
//

import SwiftUI

struct CountdownTimerView: View {
    @StateObject var viewModel = speedDateViewModel()
    @State var timeRemaining = 0
    
    var geoReader: GeometryProxy
    @State var isStartNow = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
          
          
                VStack{
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
                    .frame(width: geoReader.size.width * 0.95, height: geoReader.size.height * 0.1)
                    .background(Color.mainGrey)
                    .foregroundColor(Color.iceBreakrrrBlue)
                    .cornerRadius(geoReader.size.width * 0.05)
                    .shadow(radius: 10, x: 3, y: 10)
                }
    
    
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

struct CountdownTimerView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{geo in
            VStack{
                CountdownTimerView(timeRemaining: 80400, geoReader: geo )
            }
            .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
        }
    }
}
