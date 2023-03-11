//
//  PopoverContent.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/11/23.
//

import SwiftUI

struct PopoverView: View {
    @Binding var showingPopover: Bool
    
    var body: some View {
        ZStack{
            Color.mainBlack
                .ignoresSafeArea()
            
            VStack(spacing: 10){
                Text("Welcome to IceBreakrrr:")
                    .foregroundColor(.white)
                    .font(.system(size: 35))
                    .multilineTextAlignment(.center)
                
                Text("the dating app where you're the Matchmaker!")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 25))
                
                Spacer()
                   .frame(height: 30)
                   
                
                Text("Here's how it works:")
                    .foregroundColor(.white)
                    .font(.system(size: 30))
                    .multilineTextAlignment(.center)
                    .padding(.bottom,5)
                
                Text("- Answer the questions")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                
                Text("- Swipe the cards")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                
                Text("- Every week get a match")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                
                Text("- Meet match via the Events tab")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                
                 Spacer()
                    .frame(height: 100)
                
                Button(action: {
                    showingPopover.toggle()
                }) {
                   Text("Got it")
                        .bold()
                        .frame(width: 300, height: 70)
                        .background(Color.iceBreakrrrPink)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .shadow(radius: 8, x: 10, y:10)
                }
            }
        }
    
    }
}

struct PopoverView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverView(showingPopover: .constant(false))
    }
}
