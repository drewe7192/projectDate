//
//  TabCards.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/29/22.
//

import SwiftUI

struct TabCards: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20){
                ForEach(viewModel.people, id: \.id) { item in
                    //switch statement
                    switch item.test {
                    case 1:
                        HStack{
                            //find specific Id in entire list
                            if let ndx = viewModel.people.firstIndex(where: {$0.id == item.id}) {
                                //if theres a item in list after this current one
                                if ndx + 1 < viewModel.people.count {
                                    let nextItem = viewModel.people[ndx + 1]
                                    if nextItem.test == 1 {
                                        TabCard(item: item)
                                            .padding(.trailing)
                                        TabCard(item: nextItem)
                                    }
                                }
                            }
                        }
                    case 2:
                        TabCardBig(item: item)
                            .frame(maxWidth: .infinity)
                    default:
                        TabCard(item: item)
                        
                    }
                }
            }
        }
    }
}

struct TabCards_Previews: PreviewProvider {
    static var previews: some View {
        TabCards(viewModel: HomeViewModel(forPreview: true))
    }
}
