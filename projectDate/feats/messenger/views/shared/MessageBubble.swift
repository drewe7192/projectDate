//
//  MessageBubble.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/31/23.
//

import SwiftUI

struct MessageBubble: View {
    var message: MessageModel
    @State private var showTime = false
    
    var body: some View {
        VStack(alignment: message.received ? .leading: .trailing){
            HStack{
                Text(message.text)
                    .foregroundColor(.white)
                    .padding()
                    .background(message.received ?
                                Color.mainGrey : Color.iceBreakrrrBlue)
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment: message.received ?
                .leading : .trailing)
            .onTapGesture {
                showTime.toggle()
            }

            // show the time message was made/received
            if showTime{
                Text("\(message.timeStamp.formatted(.dateTime.hour().minute()))")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(message.received ? .leading : .trailing,25)
            }
        }
        .frame(maxWidth: .infinity, alignment:
                message.received ? .leading : .trailing)
        .padding(message.received ? .leading : .trailing)
        .padding(.horizontal, 10)
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(message: MessageModel(id: "233", received: false, text: "holla at me Im getting it outchea ya heard??", timeStamp: Date()))
    }
}
