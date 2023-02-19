//
//  CreateCardsView.swift
//  projectDate
//
//  Created by DotZ3R0 on 2/4/23.
//

import SwiftUI

struct CreateCardsView: View {
    enum LikeDislike: Int {
        case like, dislike, none
    }
    
    @State var question: String = ""
    @State var answerA: String = ""
    @State var answerB: String = ""
    @State var answerC: String = ""
    @State var categoryType: String = ""
    @State var selectedCategories: [String] = []
    @State var profileType: String = ""
    
    @State private var showFriendDisplay: Bool = false
    @State private var displayCreateButton: Bool = true
    @State private var isLoading: Bool = false
    @State var swipeStatus: LikeDislike = .none
    
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var viewRouter: ViewRouter
    @Binding var showCardCreatedAlert: Bool
    
    var body: some View {
        NavigationView{
            GeometryReader{ geoReader in
                ZStack{
                    Color.mainBlack
                        .ignoresSafeArea()
                    
                    loadingIndicator
                    VStack{
                        Text("Create New Card")
                            .font(.system(size: 40))
                            .position(x: geoReader.frame(in: .local).midX , y: geoReader.size.height * 0.03)
                        
                        cards(for: geoReader)
                    }
                
                }
                .position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY )
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func createCard(){
        viewModel.createCards.removeAll()
        displayCreateButton = false
        isLoading = true
        viewModel.createNewCard(
            id: UUID().uuidString,
            question: question,
            choices: [answerA,answerB,answerC],
            categoryType: categoryType,
            profileType: profileType) { (success) -> Void in
                if success{
                    viewRouter.currentPage = .confirmationPage
                    isLoading = false
//                    showCardCreatedAlert = true
                    
                } else{
                    viewRouter.currentPage = .failedPage
                }
                
            }
        
        
        
    }
    
    private func cards(for geoReader: GeometryProxy) -> some View {
        ZStack{
            //the order of these cards will be 0,1,2 as expected
            //but since its a Zstack the last cards in the index are on top of the stack
            ForEach(viewModel.createCards) { card in
                //this is showing only the last 4 cards
                // as explained above the card indices are reversed cause of ZStack
                // display each card counting backwards till you reach the 4th to last card in the index
                // after that dont display anymore cards. Notice the array will update after you swipe each card
                //Change the 4 to show more cards in deck
                if Int(card.id) ?? 0 > viewModel.createCards.count - 5 {
                    CreateCardView(
                        card: card,
                        onRemove: {
                            removedUser in
                            //remove card that equals current id
                            viewModel.createCards.removeAll {
                                $0.id == removedUser.id
                            }
                            
                            //after removing last card
                            if (removedUser.id == "0"){
                                displayCreateButton = false
                                isLoading = true
                                createCard()
                            }
                            
                        },
                        swipeStatus: $swipeStatus,
                        question: $question,
                        answerA: $answerA,
                        answerB: $answerB,
                        answerC: $answerC,
                        categoryType: $categoryType,
                        profileType: $profileType)
                    .animation(.spring())
                    .frame(width:
                            viewModel.createCards.cardWidth(in: geoReader,
                                                            cardId: Int(card.id) ?? 0), height: 700)
                    // gives the ability to see the cards under the top one
                    .offset(x: 0,
                            y: viewModel.createCards.cardOffset(
                                cardId: Int(card.id) ?? 0))
                   
                }
            }
        }
    }
    
    var loadingIndicator: some View {
        ZStack{
            if isLoading{
                Color.black
                    .opacity(0.25)
                    .ignoresSafeArea()
                
                ProgressView()
                    .font(.title2)
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .cornerRadius(10)
            }
        }
    }
}

struct CreateCardsView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCardsView(showCardCreatedAlert: .constant(true))
    }
}
