//
//  DropViewDelegate.swift
//  projectDate
//
//  Created by dotZ3R0 on 8/28/22.
//

import SwiftUI

//Drop Delegate functions... 
struct DropViewDelegate: DropDelegate {
    let item: String
    @Binding var items: [String]
    @Binding var draggedItem: String?
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem = self.draggedItem else {
            return
        }
        
        if draggedItem != item {
            let from = items.firstIndex(of: draggedItem)!
            
            let to = items.firstIndex(of: item)!
            withAnimation(.default) {
                self.items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
            }
        }
    }
}

