//
//  CardsViewModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 7/9/23.
//

import Foundation

class CardsViewModel: ObservableObject {
    @Published var updateCardData: Bool = false
    
    public func saveCards(viewModel: LiveViewModel){
        //make a cardGroup out of all the cards user swiped this week
        viewModel.getSwipedRecordsThisWeek() {(swipedRecords) -> Void in
            if !swipedRecords.isEmpty {
                viewModel.saveSwipedCardGroup(swipedRecords: swipedRecords)
                //not using this func right now but will in the future
                viewModel.getSwipedCardsFromSwipedRecords(swipedRecords: swipedRecords)
            }
        }
    }
}

