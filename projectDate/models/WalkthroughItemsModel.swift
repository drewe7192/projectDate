//
//  WalkthroughItemsModel.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 8/1/25.
//

import SwiftUI

struct WalkthroughItem: Identifiable {
    var id: String = UUID().uuidString
    var image: String
    var title: String
    var description: String
    
    /// These are the locations of each icon in the view, you can customize location if needed
    var scale: CGFloat = 1
    var anchor: UnitPoint = .center
    var offset: CGFloat = 0
    var rotation: CGFloat = 0
    var zindex: CGFloat = 0
    var extraOffset: CGFloat = -350
}

let walkthroughItems: [WalkthroughItem] = [
    .init(
        image: "rectangle.split.3x1",
        title: "The Problem",
        description: "Swipes miss the details. We focus on what really matters — the little things",
        scale: 1
    ),
    .init(
        image: "sparkles",
        title: "The Promise",
        description: "Discover small quirks and shared interests that spark big connections.",
        scale: 0.4,
        anchor: .topLeading,
        offset: -70,
        rotation: 30
    ),
    .init(
        image: "sparkle.magnifyingglass",
        title: "BlindChats",
        description: "Go live instantly when someone else is online. No swipes. No pressure. Just connection.",
        scale: 0.4,
        anchor: .bottomLeading,
        offset: -50,
        rotation: 160,
        extraOffset: -120
    ),
    .init(
        image: "clock",
        title: "SpeedDates",
        description: "Coming Soon",
        scale: 0.4,
        anchor: .bottomLeading,
        offset: -60,
        rotation: -35
    ),
    .init(
        image: "arrow.right.circle.fill",
        title: "Start Discovering LittleBigThings",
        description: "",
        scale: 0.4,
        anchor: .bottomLeading,
        offset: -50,
        rotation: 250,
        extraOffset: -100
    )
]
