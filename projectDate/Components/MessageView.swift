//
//  MessageView.swift
//  projectDate
//
//  Created by Drew Sutherlan on 8/7/22.
//

import SwiftUI

struct MessageView: View {
    var messageArray = ["Hello guy", "what the hell it be ya feel?",
                        "Ive been outchea vibin ya heard me?", "blah nlah long converstion loing text blah blah more blah blah"]
    
    var body: some View {
        VStack {
            VStack {
                TitleRow()
                
                ScrollView{
                    ForEach(messageArray, id: \.self) {text in
                        MessageBubble(message: Message(id:
                                                      "22334", text: text, receieved: true, timeStamp: Date()))
                    }
                }
                .padding(.top, 10)
                .background(.white)
                .cornerRadius(30, corners:[.topLeft, .topRight])
            }
            .background(Color("Peach"))
            
            MessageField()
        }
    }
    
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
