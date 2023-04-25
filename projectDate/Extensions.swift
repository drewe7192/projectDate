//
//  Extensions.swift
//  projectDate
//
//  Created by DotZ3R0 on 8/7/22.
//

import Foundation
import SwiftUI
import HMSSDK

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func getRootViewController()->UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
    
    func stacked(at position: Int, in total: Int) -> some View {
          let offset = Double(total - position)
          return self.offset(x: offset * 20, y: 0)
      }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension DragGesture.Value {
    func percentage(in geometry: GeometryProxy) -> CGFloat {
        abs(translation.width / geometry.size.width)
    }
}

extension Array where Element == CardModel {
    
    func cardOffset(cardId: Int) -> CGFloat {
        // done really get this logic
        CGFloat(count - 1 - cardId) * 8
    }
    
    func cardWidth(in geometry: GeometryProxy,
                   cardId: Int) -> CGFloat {
        // what does this have to do with width? 
        geometry.size.width - cardOffset(cardId: cardId)
    }
    
    func unique<T:Hashable>(by: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(by(value)) {
                set.insert(by(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
}

extension Array where Element == SwipedRecordModel {
    
    func unique<T:Hashable>(by: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(by(value)) {
                set.insert(by(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
}

extension Color {
    static let mainBlack = Color("mainBlack")
    static let mainGrey = Color("mainGrey")
    static let iceBreakrrrBlue = Color("IceBreakrrrBlue")
    static let iceBreakrrrPink = Color("IceBreakrrrPink")
}


extension String {
    //havent use this but maybe in the future
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return UIImage(data: data)
        }
        return nil
    }
}

extension UIImage {
    //havent use this but maybe in the future
    func toPngString() -> String? {
        let data = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
    
    //havent use this but maybe in the future
    func toJpegString(compressionQuality cq: CGFloat) -> String? {
        let data = self.jpegData(compressionQuality: cq)
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}

extension FacetimeView {
    class ViewModel: ObservableObject, HMSUpdateListener{

        @Published var addVideoView: ((_ videoView: HMSVideoTrack) -> ())?
        @Published var removeVideoView: ((_ videoView: HMSVideoTrack) -> ())?


        func on(join room: HMSRoom) {

        }

        func on(room: HMSRoom, update: HMSRoomUpdate) {

        }

        func on(peer: HMSPeer, update: HMSPeerUpdate) {

        }

        func on(track: HMSTrack, update: HMSTrackUpdate, for peer: HMSPeer) {
            switch update {
            case .trackAdded:
                if let videoTrack = track as? HMSVideoTrack {
                    addVideoView?(videoTrack)
                }
            case .trackRemoved:
                if let videoTrack = track as? HMSVideoTrack {
                    removeVideoView?(videoTrack)
                }
            default:
                break
            }
        }

        func on(error: Error) {

        }

        func on(message: HMSMessage) {

        }

        func on(updated speakers: [HMSSpeaker]) {

        }

        func onReconnecting() {

        }

        func onReconnected() {

        }


    }
}


extension Date {

  static func today() -> Date {
      return Date()
  }

  func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.next,
               weekday,
               considerToday: considerToday)
  }

  func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.previous,
               weekday,
               considerToday: considerToday)
  }

  func get(_ direction: SearchDirection,
           _ weekDay: Weekday,
           considerToday consider: Bool = false) -> Date {

    let dayName = weekDay.rawValue

    let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

    
    assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

    let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1

    let calendar = Calendar(identifier: .gregorian)

    if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
      return self
    }

    var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
    nextDateComponent.weekday = searchWeekdayIndex

    let date = calendar.nextDate(after: self,
                                 matching: nextDateComponent,
                                 matchingPolicy: .nextTime,
                                 direction: direction.calendarSearchDirection)

    return date!
  }

}

// MARK: Helper methods
extension Date {
  func getWeekDaysInEnglish() -> [String] {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en_US_POSIX")
    return calendar.weekdaySymbols
  }

  enum Weekday: String {
    case monday = "monday",
         tuesday = "tuesday",
         wednesday = "wednesday",
         thursday = "thursday",
         friday = "friday",
         saturday = "saturday",
         sunday = "sunday",
        other = "pick matchday"
  }

  enum SearchDirection {
    case next
    case previous

    var calendarSearchDirection: Calendar.SearchDirection {
      switch self {
      case .next:
        return .forward
      case .previous:
        return .backward
      }
    }
  }
}
