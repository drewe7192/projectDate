//
//  HomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/18/23.
//

import SwiftUI

struct LocalHomeView: View {
    @State private var showFriendDisplay = true
    
    var body: some View {
        NavigationView{
            GeometryReader{geoReader in
                ZStack{
                    Color("Gray")
                        .ignoresSafeArea()
                    VStack{
                        headerSection(for: geoReader)
                        Divider()
                        Spacer()
                            .frame(height: 20)
                        eventSection(for: geoReader)
                        Spacer()
                            .frame(height: 20)
                        cardsSection(for: geoReader)
                        Spacer()
                    }
                }.position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY )
            }
        }
       
    }
    
    private func headerSection(for geoReader: GeometryProxy) -> some View {
        VStack{
            HStack{
                Text("Logo")
                    .bold()
                    .font(.system(size: 30))
                
                VStack(alignment: .trailing){
                    Toggle("", isOn: $showFriendDisplay)
                    Text(showFriendDisplay ? "Friendship" : "Dating" )
                        .bold()
                }
            }
        }
    }
    
    private func eventSection(for geoReader: GeometryProxy) ->  some View {
        VStack{
            Text("Next Event")
                .bold()
                .font(.system(size: 30))
                .padding(.trailing,200)
            NavigationLink(destination: EventInfoView()){
                EventCardView()
            }
         
        }
    }
    
    private func cardsSection(for geoReader: GeometryProxy) -> some View {
        VStack{
            Text("Little Things")
                .bold()
                .font(.system(size: 30))
                .padding(.trailing,200)
            SwipeCardsView()
        }
    }
}

struct LocalHomeView_Previews: PreviewProvider {
    static var previews: some View {
        LocalHomeView()
    }
}
