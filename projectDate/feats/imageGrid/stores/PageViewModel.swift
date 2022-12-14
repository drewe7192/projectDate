//
//  PageViewModel.swift
//  projectDate
//
//  Created by dotZ3R0 on 8/27/22.
//

import SwiftUI

class PageViewModel: ObservableObject {
    @Published var selectedTab = "tabs"
    
    @Published var urls: [Page] = [
        Page(url: URL(string: "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg")!),
        Page(url: URL(string: "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg")!),
        Page(url: URL(string: "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg")!),
        Page(url: URL(string: "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg")!),
        Page(url: URL(string: "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg")!),
        Page(url: URL(string: "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg")!),
        Page(url: URL(string: "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg")!),
        Page(url: URL(string: "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg")!)
    ]
}

