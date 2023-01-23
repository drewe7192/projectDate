//
//  CircularProgressView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/21/23.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    var body: some View {
        
        ZStack{
            Color("IceBreakrrrBlue")
                .ignoresSafeArea()
            
            Circle()
                .stroke(
                    Color.white.opacity(0.5),
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

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.5)
    }
}
