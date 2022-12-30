//
//  TopTabView.swift
//  projectDate
//
//  Created by dotZ3R0 on 11/11/22.
//

import SwiftUI

struct TopRatedTabView: View {
    @StateObject var viewModel = HomeViewModel()
    var body: some View {
        TabCards(viewModel: HomeViewModel(forPreview: true))
    }
}

struct TopRatedTabView_Previews: PreviewProvider {
    static var previews: some View {
        TopRatedTabView()
    }
}
