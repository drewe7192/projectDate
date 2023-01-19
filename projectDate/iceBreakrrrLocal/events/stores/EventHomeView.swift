//
//  EventHomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import SwiftUI

struct EventHomeView: View {
    var body: some View {
        ScrollView{
            VStack{
                ForEach(0..<3) { item in
                    NavigationLink(destination: EventInfoView()){
                        EventCardView()
                    }
                  
                }
            }
        }
    }
}

struct EventHomeView_Previews: PreviewProvider {
    static var previews: some View {
        EventHomeView()
    }
}
