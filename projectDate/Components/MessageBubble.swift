//
//  MessageBubble.swift
//  projectDate
//
//  Created by Drew Sutherlan on 8/7/22.
//

import SwiftUI

struct MessageBubble: View {
    var message: Message
    @State private var showTime = false
    
    var body: some View {
        VStack(alignment: message.receieved ? .leading: .trailing){
            HStack{
                Text(message.text)
                    .padding()
                    .background(message.receieved ?
                                Color("Gray") : Color("Peach"))
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment: message.receieved ?
                .leading : .trailing)
            .onTapGesture {
                showTime.toggle()
            }
            
            if showTime{
                Text("\(message.timeStamp.formatted(.dateTime.hour().minute()))")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(message.receieved ? .leading : .trailing,25)
            }
        }
        .frame(maxWidth: .infinity, alignment:
                message.receieved ? .leading : .trailing)
        .padding(message.receieved ? .leading : .trailing)
        .padding(.horizontal, 10)
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(message: Message(id: "233", text: "holla at me Im getting it outchea ya heard??"
                                       ,receieved: false, timeStamp: Date()))
    }
}
