//
//  ImageGridView.swift
//  projectDate
//
//  Created by dotZ3R0 on 8/27/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct ImageGridView: View {
    @StateObject var pageData = PageViewModel()
    @Namespace var animation
    
    //Columns...
    let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)
    @State var items = ["1","2","3","4","5","6","7","8","9"]
    @State var items2 = [
        "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg",
        "https://i.pinimg.com/550x/0c/17/ae/0c17ae80425d53c2dbd359864166e5f9.jpg",
        "https://i.pinimg.com/236x/17/fc/ab/17fcab1436af476473e188e2b6895e69.jpg",
        "https://images.hdqwalls.com/wallpapers/anime-ninja-4k-lo.jpg",
        "https://i.pinimg.com/originals/99/59/1b/99591bbc318ecd41ae7bbf39a9106e12.jpg",
        "https://i.pinimg.com/564x/5c/a3/df/5ca3df0029c86fd5b18c3b55cc3bea52.jpg",
        "https://i.pinimg.com/564x/f9/fd/0b/f9fd0bdd7914c8ae047a3dea1d3d5719.jpg",
        "https://i.pinimg.com/564x/e7/2e/05/e72e05f7a02f1039d5f8f07bc7519ee7.jpg",
        "https://i.pinimg.com/564x/41/dd/5e/41dd5ecc3f1cb861d65d4a9c7778eaeb.jpg"
    ]
    @State var draggedItem: String?
    
    var body: some View {
        ScrollView {
        LazyVGrid(columns: columns, spacing: 1) {
            ForEach(items2, id: \.self){item in
                
                AsyncImage(url: URL(string: item)) { phase in
                    switch phase{
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: 100, height: 100)
                    default:
                        Image(systemName: "photo")
                    }
                }
//Drag and Drop...
                    .onDrag({
                        self.draggedItem = item
                        //Sending ID for sample....
                        return NSItemProvider(contentsOf: URL(string: "\(item)")!)!
                    })
                    .onDrop(of: [.url], delegate: DropViewDelegate(item: item, items: $items2, draggedItem: $draggedItem))
            }
        }
        .frame(height: 300)
        .aspectRatio(1, contentMode: .fit)
        .clipped()
        }
    }
}







struct ImageGridView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGridView()
    }
}
