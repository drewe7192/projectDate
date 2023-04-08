//
//  MessageView.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/31/23.
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
                            Spacer()
                                  .frame(height: 40)
                        }
                    }
                    .padding(.top, 10)
                    .background(Color.mainBlack)
                    .cornerRadius(30, corners:[.topLeft, .topRight])
                    .onChange(of:
                                viewModel.lastMessageId) { id in
                        withAnimation{
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                }
            }
            MessageField()
                .environmentObject(viewModel)
        }
        .background(Color.mainBlack)
        .onAppear{
            viewModel.getMessages()
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
