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
    @StateObject var viewModel = speedDateViewModel()
    @Binding var timeRemaining: Int
    
    var geoReader: GeometryProxy
    @Binding var isStartNow: Bool
    @Binding var isTimeEnded: Bool
    let speedDates: [SpeedDateModel]
    @State private var profilesToMessage: [ProfileModel] = []
    @State private var tokens: [String] = []
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let db = Firestore.firestore()
    
    var body: some View {
        VStack{
            if speedDates.isEmpty {
                Text("Swipe for SpeedDates")
                //normal styling for button
                    .multilineTextAlignment(.center)
                    .font(.title.bold())
                    .frame(width: geoReader.size.width * 0.95, height: geoReader.size.height * 0.1)
                    .background(Color.mainGrey)
                    .foregroundColor(Color.iceBreakrrrBlue)
                    .cornerRadius(geoReader.size.width * 0.05)
                    .shadow(radius: 10, x: 3, y: 10)
                    .opacity(0.3)
            }
            else if isTimeEnded {
                Text("Missed your window!")
                //normal styling for button
                    .multilineTextAlignment(.center)
                    .font(.title.bold())
                    .frame(width: geoReader.size.width * 0.95, height: geoReader.size.height * 0.1)
                    .background(Color.mainGrey)
                    .foregroundColor(Color.iceBreakrrrBlue)
                    .cornerRadius(geoReader.size.width * 0.05)
                    .shadow(radius: 10, x: 3, y: 10)
                    .opacity(0.3)
                
            } else{
                Text(
                    //just the display
                    (isStartNow ? "Start Now!": "") +
                    (isStartNow ? "" : displayCountdown()))
                //main logic for countdown
                .onReceive(timer) { _ in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    } else if timeRemaining == 0 {
                        
//                        getProfilesToMessage() {(profiles) -> Void in
//                            if !profiles.isEmpty {
//                                sendStartMessage(profiles: profiles)
//                            }
//                        }
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
                .opacity(isStartNow ? 1 : 0.3)
            }
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
    
//    private func getProfilesToMessage(completed: @escaping(_ profiles: [ProfileModel]) -> Void){
////        var matchIds: [String] = []
////
////        for matchRecord in matchRecords {
////            matchIds.append(matchRecord.matchProfileId)
////        }
//        if !speedDates.isEmpty {
//            db.collection("profiles")
//                .whereField("speedDateIds", isEqualTo: speedDates.first!.id)
//                .getDocuments() { (querySnapshot, err) in
//                    if let err = err {
//                        print("Error getting speedDateIds with profiles: \(err)")
//                        completed([])
//                    } else {
//                        for document in querySnapshot!.documents {
//                            //                        print("\(document.documentID) => \(document.data())")
//                            let data = document.data()
//                            if !data.isEmpty{
//                                let profile = ProfileModel(id: data["id"] as? String ?? "", fullName: data["fullName"] as? String ?? "", location: data["location"] as? String ?? "", gender: data["gender"] as? String ?? "", matchDay: data["matchDay"] as? String ?? "", messageThreadIds: data["messageThreadIds"] as? [String] ?? [], speedDateIds: data["speedDateIds"] as? [String] ?? [], fcmTokens: data["fcmTokens"] as? [String] ?? [])
//
//                                self.profilesToMessage.append(profile)
//                            }
//                        }
//                        completed(self.profilesToMessage)
//                    }
//                }
//        }
//
//
//    }
//
//    private func sendStartMessage(profiles: [ProfileModel]) {
//        guard let url = URL(string: "https://us-central1-projectdate-a365b.cloudfunctions.net/startSpeedDateMessage") else { fatalError("Missing URL") }
//
//        for profile in profiles {
//            profile.fcmTokens.forEach { toke in
//                self.tokens.append(toke)
//            }
//
//        }
//
//        let json: [String: Any]  = [
//            "tokens": self.tokens,
//        ]
//
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "POST"
//        urlRequest.httpBody = jsonData
//        urlRequest.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//            if let error = error {
//                print("Request error: ", error)
//             //   completed("")
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse else { return }
//
//            if response.statusCode == 200 {
//                guard let data = data else { return }
//                DispatchQueue.main.async {
//                    do {
//                        //let decodedUsers = try JSONDecoder().decode(Response.self, from: data)
//                        let roomId = String(data:data, encoding: .utf8)
//                     //   completed(viewModel.roomId)
//                    } catch let error {
//                       // completed("")
//                        print("Error decoding: ", error)
//                    }
//                }
//            }
//        }
//        dataTask.resume()
//    }
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
