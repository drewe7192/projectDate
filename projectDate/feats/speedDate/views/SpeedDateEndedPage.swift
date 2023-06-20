//
//  SpeedDateEndedPage.swift
//  projectDate
//
//  Created by DotZ3R0 on 6/17/23.
//

import SwiftUI

struct SpeedDateEndedPage: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        GeometryReader{ geoReader in
            ZStack{
                Color.mainBlack
                    .ignoresSafeArea()
                
                VStack(spacing: 20){
                   
                    
                    Text("SpeedDate Ended")
                        .bold()
                        .font(.system(size: geoReader.size.height * 0.04))
                        .foregroundColor(.white)
                    
                    Text("Tap button to return home and coninute speedDating!")
                        .bold()
                        .font(.system(size: geoReader.size.height * 0.04))
                        .foregroundColor(.white)
                    
                    Button(action: {
                        viewRouter.currentPage = .homePage
                    }) {
                       Text("Continue SpeedDating")
                            .bold()
                            .frame(width: 300, height: 70)
                            .background(.green)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(radius: 8, x: 10, y:10)
                    }
                }
            }.position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY )
        }
    }
}

struct SpeedDateEndedPage_Previews: PreviewProvider {
    static var previews: some View {
        SpeedDateEndedPage()
    }
}
