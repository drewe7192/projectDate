//
//  MessageHomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/25/22.
//

import SwiftUI

struct MessageHomeView: View {
    var body: some View {
        VStack{
            SearchInput()
                .padding(.bottom, 100)
            
            ForEach(0..<3){ item in
                NavigationLink(destination: MessageView()) {
                    MessageCardView()
                }
              
            }
            Spacer()
        }
      
    }
}

struct MessageHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MessageHomeView()
    }
}
