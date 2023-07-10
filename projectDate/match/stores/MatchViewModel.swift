//
//  MatchViewModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 7/9/23.
//

import Foundation

class MatchViewModel: ObservableObject {
    @Published var blah: Bool = false
    
    public func getMatchData(){
        let format = DateFormatter()
        //The -1 is added at the end because Calendar.current.component(.weekday, from: Date()) returns values from 1-7 but weekdaySymbols expects array indices
        let weekday = format.weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1]
        
        //SpeedDate Sundays!
        //        if(weekday == "Sunday") {
        //            viewModel.getMatchRecordsForPreviousWeek() {(matchRecordsPreviousWeek) -> Void in
        //                // If theres no matchRecords for this week run match logic and find matches
        //                if matchRecordsPreviousWeek.isEmpty {
        //                    getCardGroups() {(userCardGroup) -> Void in
        //                        if userCardGroup.userCardGroup.id != "" {
        //                            findMatches(cardGroups: userCardGroup) {(successFullMatches) -> Void in
        //                                if !successFullMatches.isEmpty {
        //                                    viewModel.saveMatchRecords(matches: successFullMatches, isNew: true)
        //                                    //delaying routing to make sure matchRecords save
        //                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
        //                                        viewRouter.currentPage = .matchPage
        //                                    }
        //                                }
        //                            }
        //                        } else {
        //                            viewRouter.currentPage = .matchPage
        //                        }
        //                    }
        //                } else if matchRecordsPreviousWeek.contains(where: { mrec in mrec.isNew == true}) {
        //                    viewRouter.currentPage = .matchPage
        //                }
        //            }
        //        }
    }
    
}
