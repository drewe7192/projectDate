//
//  VideoViewModel.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 3/29/25.
//

import Foundation

class VideoViewModel: ObservableObject {
    @Published var isFullScreen: Bool = false
    @Published var isButtonDisabled: Bool = false
    @Published var roomCode: String = ""
}
