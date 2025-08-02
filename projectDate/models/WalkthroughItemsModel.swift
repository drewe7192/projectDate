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
        image: "app.gift.fill",
        title: "The Little things are important.",
        description: "Hobbies, Cleaniness, Quirks, blah: the million little things is what really shapes a friendship. The little things can become Big things at anytime.",
        scale: 1
    ),
    .init(
        image: "globe.europe.africa",
        title: "The Big things are important.",
        description: "Career, Life Goals, Family, and Health; the bigs things shape who are now and for the future. Geting to know the important stuff in a person life will get you closer than a dating app.",
        scale: 0.6,
        anchor: .topLeading,
        offset: -70,
        rotation: 30
    ),
    .init(
        image: "checkmark.circle.badge.questionmark.fill",
        title: "Q&A feature",
        description: "The Question & Answer feature gives you the freedom to ask anything, and get multiple answer. Best answer wins",
        scale: 0.5,
        anchor: .bottomLeading,
        offset: -60,
        rotation: -35
    ),
    .init(
        image: "person.line.dotted.person",
        title: "BlindChat feature",
        description: "They say Love is blind, but over here we think the same goes with friendships. Using this feature your able to get to know someone without the pressure of looks first, get to know you second",
        scale: 0.4,
        anchor: .bottomLeading,
        offset: -50,
        rotation: 160,
        extraOffset: -120
    ),
    .init(
        image: "figure.cooldown.circle.fill",
        title: "Cool down after a workout",
        description: "",
        scale: 0.35,
        anchor: .bottomLeading,
        offset: -50,
        rotation: 250,
        extraOffset: -100
    )
]
