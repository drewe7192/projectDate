//
//  SearchInput.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/17/22.
//

import SwiftUI

struct SearchInput: View {
    @Binding var searchText: String
    @State private var isEditing = false
    
    var body: some View {
        GeometryReader{geoReader in
            HStack {
                TextField("Search ...", text: $searchText)
                    .padding(geoReader.size.height * 0.01)
                    .padding(.horizontal, geoReader.size.height * 0.1)
                    .background(Color(.systemGray6))
                    .cornerRadius(geoReader.size.height * 0.03)
                    .overlay(
                        HStack{
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, geoReader.size.width * 0.03)
                            
                            if isEditing{
                                Button(action: {
                                    self.searchText = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, geoReader.size.height * 0.01)
                                }
                            }
                        }
                    )
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        self.isEditing = true
                    }
                
//                if isEditing {
//                    Button(action: {
//                        self.isEditing = false
//                        self.searchText = ""
//                        
//                    }) {
//                        Text("Cancel")
//                    }
//                    .padding(.trailing, 10)
//                    .transition(.move(edge: .trailing))
//                    .animation(.default)
//                }
            }
//            .position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY)
        }
    
    }
}

struct SearchInput_Previews: PreviewProvider {
    static var previews: some View {
        SearchInput(searchText: .constant(""))
    }
}
