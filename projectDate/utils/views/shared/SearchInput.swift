//
//  SearchInput.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/17/22.
//

import SwiftUI

struct SearchInput: View {
    @State private var name: String = "Search"
    
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(.black)
            
            TextField("", text: $name)
        }
        .frame(width: 400, height: 40)
        .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.black, lineWidth: 2))
    }
}

struct SearchInput_Previews: PreviewProvider {
    static var previews: some View {
        SearchInput()
    }
}
