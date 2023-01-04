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
                ForEach(viewModel.people, id: \.firstName) { item in
                    HStack{
                        TabCard(item: item)
                        TabCard(item: item)
                    }
                    tabCardBig
                }
            }
        }
    }
    
    private var tabCardBig: some View {
        VStack{
            NavigationLink(destination: ProfileView(participant: MockService.profileSampleData)) {
                Image("animeGirl")
                    .resizable()
            }
            .frame(width: 300, height: 300)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(30)
            
            Text("Hane hane")
                .bold()
            
            Text("West Palm Beach, FL")
        }
    }
}

struct TabCards_Previews: PreviewProvider {
    static var previews: some View {
        TabCards(viewModel: HomeViewModel(forPreview: true))
    }
}
