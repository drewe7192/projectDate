//
//  NewTabView.swift
//  projectDate
//
//  Created by DotZ3R0 on 11/21/22.
//

import SwiftUI

struct RecommendedTabView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
     TabCards(viewModel: HomeViewModel(forPreview: true))
    }
}

struct RecommendedTabView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendedTabView()
    }
}
