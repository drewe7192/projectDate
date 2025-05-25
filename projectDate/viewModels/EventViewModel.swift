//
//  SpeedMeetViewModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 7/9/23.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore


class EventViewModel: ObservableObject {
    @Published var speedMeet: Bool = false
    @Published var messageInfo: [AnyHashable: Any] = [:]
    @Published var isFullScreen: Bool = false
    
    let db = Firestore.firestore()
    
//    public func getSpeedDate(speedDateIds: [String], completed: @escaping(_ speedDates: [SpeedDateModel]) -> Void){
//        if !speedDateIds.isEmpty {
//            let firstSpeedDate = speedDateIds.first!
//            
//            db.collection("speedDates")
//                .whereField("id", isEqualTo: firstSpeedDate)
//                .addSnapshotListener{ (querySnapshot, error) in
//                    if let error {
//                        print("Error getting documents from speedDates: \(error)")
//                        completed([])
//                    } else {
//                        for document in querySnapshot!.documents {
//                            let data = document.data()
//                            
//                            if !data.isEmpty{
//                                let timeStampEvent = data["eventDate"] as? Timestamp
//                                let eventDate = timeStampEvent?.dateValue()
//                                
//                                let timeStampCreated = data["createdDate"] as? Timestamp
//                                let createdDate = timeStampCreated?.dateValue()
//                                
//                                let speedDate = SpeedDateModel(
//                                    id: data["id"] as? String ?? "",
//                                    maleRoomCode: data["maleRoomCode"] as? String ?? "",
//                                    femaleRoomCode: data["femaleRoomCode"] as? String ?? "",
//                                    roomId: data["roomId"] as? String ?? "",
//                                    matchProfileIds: data["matchProfileIds"] as? [String] ?? [],
//                                    eventDate: eventDate ?? Date(),
//                                    createdDate: createdDate ?? Date(),
//                                    isActive: data["isActive"] as? Bool ?? false
//                                )
//                                
//                                self.speedDates.append(speedDate)
//                            }
//                        }
//                        completed(self.speedDates)
//                    }
//                }
//        }
//    }
    
//    public func setLineAndTime(viewModel: SpeedMeetViewModel, liveViewModel: liveViewModel){
//        self.setPlaceInLine(viewModel: SpeedMeetViewModel, liveViewModel: liveViewModel){(placeIn) -> Void in
//            if placeIn != 0 {
//                self.setTimeRemaining(viewModel: liveViewModel){(timeRemaining) -> Void in
//                    if timeRemaining != 0 {
//                        self.timeLeft(inLine: placeIn, viewModel: viewModel)
//                    }
//                }
//            }
//        }
//    }
//
//    private func timeLeft(inLine: Int, viewModel: SpeedMeetViewModel) -> Int{
//        if !viewModel.speedDates.isEmpty {
//            let eventDate = viewModel.speedDates.first!.eventDate
//            let calendar = Calendar.current
//
//            //every match gets a 10 minute window to join videoRoom
//            let tenMinsLater = calendar.date(byAdding: .minute, value: 10, to: eventDate)
//            let twentyMinsLater = calendar.date(byAdding: .minute, value: 20, to: eventDate)
//            let thirtyMinsLater = calendar.date(byAdding: .minute, value: 30, to: eventDate)
//            let fourtyMinsLater = calendar.date(byAdding: .minute, value: 40, to: eventDate)
//            let fourtyFiveMinsLater = calendar.date(byAdding: .minute, value: 45, to: eventDate)
//
//            //compares the times to the current date and time(if negative then time has passsed current time)
//            let peer1StartDate = tenMinsLater!.timeIntervalSinceNow
//            let peer1EndDate = twentyMinsLater!.timeIntervalSinceNow
//
//            let peer2StartDate = twentyMinsLater!.timeIntervalSinceNow
//            let peer2EndDate = twentyMinsLater!.timeIntervalSinceNow
//
//            let peer3StartDate = thirtyMinsLater!.timeIntervalSinceNow
//            let peer3EndDate = fourtyMinsLater!.timeIntervalSinceNow
//
//            let EndDate = fourtyFiveMinsLater!.timeIntervalSinceNow
//
//            //based on where matches are in line, if there window to join has passed we disable the button
//            switch inLine{
//            case 1:
//                do {
//                    let peerStart1 = Int(peer1StartDate)
//
//                    if peer1StartDate.sign != .minus {
//                        self.timeRemainingSpeedDateHomeView = peerStart1
//                        return 0
//                    } else if peer1EndDate.sign != .minus {
//                        self.timeRemainingSpeedDateHomeView = 0
//                        return 0
//
//                    } else {
//                        self.timeRemainingSpeedDateHomeView = 0
//                        self.isTimeEnded = true
//                        return 0
//                    }
//                }
//            case 2:
//                do {
//                    let peerStart2 = Int(peer2StartDate)
//
//                    if peer2StartDate.sign != .minus {
//                        self.timeRemainingSpeedDateHomeView = peerStart2
//                        return 0
//                    }  else if peer2EndDate.sign != .minus {
//                        self.timeRemainingSpeedDateHomeView = 0
//                        return 0
//
//                    } else {
//                        self.timeRemainingSpeedDateHomeView = 0
//                        self.isTimeEnded = true
//                        return 0
//                    }
//                }
//            case 3:
//                do {
//                    let peerStart3 = Int(peer3StartDate)
//
//                    if peer3StartDate.sign != .minus {
//                        self.timeRemainingSpeedDateHomeView = peerStart3
//                        return 0
//                    } else if peer3EndDate.sign != .minus {
//                        self.timeRemainingSpeedDateHomeView = 0
//                        return 0
//                    } else {
//                        self.timeRemainingSpeedDateHomeView = 0
//                        self.isTimeEnded = true
//                        return 0
//                    }
//                }
//            case 5:
//                do {
//                    if EndDate.sign == .minus {
//                        self.timeRemainingSpeedDateHomeView = 0
//                        self.isStartSpeedDateNow = false
//                        self.isTimeEnded = true
//                        viewModel.removeSpeedDate()
//                        return 0
//                    }
//                }
//            default:
//                break
//            }
//        }
//        return 0
//    }
//
//    private func setPlaceInLine(viewModel: SpeedMeetViewModel, liveViewModel: liveViewModel,completed: @escaping(_ placeIn: Int) -> Void) {
//        let placeInLine = viewModel.speedDates.first!.matchProfileIds.firstIndex(of: liveViewModel.userProfile.id) ?? 4
//
//        // remove 0 based index
//        self.placeInLine = placeInLine.advanced(by: 1)
//        completed(self.placeInLine)
//    }
//
//    private func setTimeRemaining(viewModel: SpeedMeetViewModel, completed: @escaping(_ timeRemaining: Int) -> Void) {
//        if !viewModel.speedDates.isEmpty{
//            let rawEventDate = viewModel.speedDates.first!.eventDate
//            let calendar = Calendar.current
//            let calendarEventDate = calendar.date(byAdding: .minute, value: 0, to: rawEventDate)
//            let eventDate = calendarEventDate!.timeIntervalSinceNow
//
//            if eventDate.sign != .minus {
//                self.timeRemainingHomeView = Int(eventDate)
//                completed(Int(eventDate))
//            }
//            completed(-1)
//        }
//        completed(-1)
//    }
}
