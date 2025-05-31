//
//  VideoViewModel.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 3/29/25.
//

import Foundation

@MainActor
class VideoViewModel: ObservableObject {
    @Published var roomCode: String = ""
    @Published var isBlurredScreen: Bool = false
}
