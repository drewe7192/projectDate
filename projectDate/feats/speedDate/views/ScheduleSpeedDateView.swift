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
              DatePicker("", selection:  $date)
                    .frame(width: 500, height: 500, alignment: .center)
                    .accentColor(.iceBreakrrrPink)
                    .labelsHidden()
                    .fixedSize()
                    
                   
            }
        }
        
    }
}

struct ScheduleSpeedDateView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleSpeedDateView()
    }
}

