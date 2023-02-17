//
//  BarProgressView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/23/23.
//

import SwiftUI

struct BarProgressView: View {
    let progress: Double
    var body: some View {
        
        ZStack{
            Color("IceBreakrrrBlue")
                .ignoresSafeArea()
            
            Circle()
                .stroke(
                    Color.black.opacity(0.5),
                    lineWidth: 10
                )
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(.white, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
      
      
    }
}

struct BarProgressView_Previews: PreviewProvider {
    static var previews: some View {
        BarProgressView(progress: 0.2)
    }
}
