//
//  EditPhotosView.swift
//  DatingApp
//
//  Created by Drew Sutherlan on 7/30/22.
//

import SwiftUI

struct EditPhotosView: View {
    
    let columns : [GridItem] = [
        GridItem(.flexible(), spacing: 0, alignment: nil),
        GridItem(.flexible(), spacing: 0, alignment: nil),
        GridItem(.flexible(), spacing: 0, alignment: nil)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(0..<9) {index in
                Rectangle()
                    .frame(width:90, height: 120)
            }
        }
    }
}

struct EditPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        EditPhotosView()
    }
}
