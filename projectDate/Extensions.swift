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
}

extension Color {
    static let mainBlack = Color("mainBlack")
    static let mainGrey = Color("mainGrey")
    static let iceBreakrrrBlue = Color("IceBreakrrrBlue")
    static let iceBreakrrrPink = Color("IceBreakrrrPink")
}
