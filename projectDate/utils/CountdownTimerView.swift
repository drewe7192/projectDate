//
//  CountdownTimerView.swift
//  projectDate
//
//  Created by DotZ3R0 on 4/4/23.
//

import SwiftUI
import FirebaseMessaging
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CountdownTimerView: View {
    @Binding var timeRemaining: Int
    
    var geoReader: GeometryProxy
    @Binding var isStartNow: Bool
    @Binding var isTimeEnded: Bool
    let speedDates: [SpeedDateModel]
    @State private var profilesToMessage: [ProfileModel] = []
    @State private var tokens: [String] = []
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    let db = Firestore.firestore()
    
    var body: some View {
        VStack{
            Text(
                //just the display
                (isStartNow ? "Start Now!": "") +
                (isStartNow ? "" : "\(displayCountdown()) left to reply"))
            //main logic for countdown
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else if timeRemaining == 0 {
                    isStartNow = true
                }
            }
                            .multilineTextAlignment(.center)
                            .font(.title2)
                            .frame(width: geoReader.size.width * 0.5, height: geoReader.size.height * 0.1)
                            .foregroundColor(Color.iceBreakrrrBlue)
                            .cornerRadius(geoReader.size.width * 0.05)
                            .opacity(isStartNow ? 1 : 0.3)
            
            
//            if speedDates.isEmpty {
//                Text("Swipe for SpeedDates")
//                //normal styling for button
//                    .multilineTextAlignment(.center)
//                    .font(.title.bold())
//                    .frame(width: geoReader.size.width * 0.95, height: geoReader.size.height * 0.1)
//                    .background(Color.secondaryColor)
//                    .foregroundColor(Color.iceBreakrrrBlue)
//                    .cornerRadius(geoReader.size.width * 0.05)
//                    .shadow(radius: 10, x: 3, y: 10)
//                    .opacity(0.3)
//            }
//            else if isTimeEnded {
//                Text("Missed your window!")
//                //normal styling for button
//                    .multilineTextAlignment(.center)
//                    .font(.title.bold())
//                    .frame(width: geoReader.size.width * 0.95, height: geoReader.size.height * 0.1)
//                    .background(Color.secondaryColor)
//                    .foregroundColor(Color.iceBreakrrrBlue)
//                    .cornerRadius(geoReader.size.width * 0.05)
//                    .shadow(radius: 10, x: 3, y: 10)
//                    .opacity(0.3)
//
//            } else{
//                Text(
//                    //just the display
//                    (isStartNow ? "Start Now!": "") +
//                    (isStartNow ? "" : displayCountdown()))
//                //main logic for countdown
//                .onReceive(timer) { _ in
//                    if timeRemaining > 0 {
//                        timeRemaining -= 1
//                    } else if timeRemaining == 0 {
//                        isStartNow = true
//                    }
//                }
//                //normal styling for button
//                .multilineTextAlignment(.center)
//                .font(.title.bold())
//                .frame(width: geoReader.size.width * 0.95, height: geoReader.size.height * 0.1)
//                .background(Color.secondaryColor)
//                .foregroundColor(Color.iceBreakrrrBlue)
//                .cornerRadius(geoReader.size.width * 0.05)
//                .shadow(radius: 10, x: 3, y: 10)
//                .opacity(isStartNow ? 1 : 0.3)
//            }
        }
    }
    
    private func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    private func displayCountdown() -> (String){
        let hours = secondsToHoursMinutesSeconds(timeRemaining).0
        let displayHours = "\(secondsToHoursMinutesSeconds(timeRemaining).0)" + "hrs "
        let displayMinutes = "\(secondsToHoursMinutesSeconds(timeRemaining).1)" + "mins "
        let displaySeconds = "\(secondsToHoursMinutesSeconds(timeRemaining).2)" + "secs "
        
        if(hours > 23){
            let displayDays = "\(hours / 24)" + (hours < 48 ? " day" : " days")
            return displayDays
        }
        return displayHours + displayMinutes + displaySeconds
    }
}

struct CountdownTimerView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{geo in
            VStack{
                CountdownTimerView(timeRemaining: .constant(0), geoReader: geo, isStartNow: .constant(false), isTimeEnded: .constant(false), speedDates: [])
            }
            .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
        }
    }
}
