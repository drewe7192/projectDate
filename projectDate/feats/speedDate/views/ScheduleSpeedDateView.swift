//
//  speedDateInfoView.swift
//  projectDate
//
//  Created by DotZ3R0 on 4/4/23.
//

import SwiftUI

struct ScheduleSpeedDateView: View {
    @State private var date = Date()
    
    var body: some View {
        ZStack{
            Color.mainBlack
                .ignoresSafeArea()
            
            VStack{
                Text("Pick a date for SpeedDate!")
                    .foregroundColor(.white)
                    .font(.system(size: 30))
                
                DatePicker(
                    "",
                    selection: $date,
                    in: Date().addingTimeInterval(200000)...
                )
                    .scaleEffect(1.5)
                    .labelsHidden()
                VStack{
                    Button(action: {
                      
                    }) {
                        Text("Schedule SpeedDate!")
                            .bold()
                            .frame(width: 300, height: 70)
                            .background(Color.mainGrey)
                            .foregroundColor(.iceBreakrrrBlue)
                            .font(.system(size: 20))
                            .cornerRadius(20)
                            .shadow(radius: 8, x: 10, y:10)
                            .opacity(self.date != Date() ? 1 : 0.5)
                    }
                }
                .padding(.top,50)
            }
        }
    }
}

struct ScheduleSpeedDateView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleSpeedDateView()
    }
}

