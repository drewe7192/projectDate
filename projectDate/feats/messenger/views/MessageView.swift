//
//  MessageView.swift
//  projectDate
//
//  Created by DotZ3R0 on 8/7/22.
//

import SwiftUI

struct MessageView: View {
    @StateObject var viewModel = MessageViewModel()
    
    var body: some View {
        VStack {
            VStack {
                TitleRow()
                
                ScrollViewReader { proxy in
                    ScrollView{
                        ForEach(viewModel.messages, id:
                                    \.id) {message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding(.top, 10)
                    .background(.white)
                    .cornerRadius(30, corners:[.topLeft, .topRight])
                    .onChange(of:
                                viewModel.lastMessageId) { id in
                        withAnimation{
                            proxy.scrollTo(id, anchor: .bottom)
                        }                        
                    }
                }
            }
            .background(Color("Peach"))
            
            MessageField()
                .environmentObject(viewModel)
        }
    }
    
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
