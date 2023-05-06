//
//  ConfirmationView.swift
//  projectDate
//
//  Created by DotZ3R0 on 2/16/23.
//

import SwiftUI

struct ConfirmationView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    let confirmationText: String
    
    var body: some View {
        GeometryReader{ geoReader in
            ZStack{
                Color.mainBlack
                    .ignoresSafeArea()
                
                VStack(spacing: 20){
              
                    
                    Image("confirmationCheck")
                        .resizable()
                        .frame(width: 300, height: 300)
                    
                    Text("\(confirmationText)")
                        .bold()
                        .font(.system(size: geoReader.size.height * 0.04))
                        .foregroundColor(.white)
                    
                    Button(action: {
                        viewRouter.currentPage = .homePage
                    }) {
                       Text("Return Home")
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

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(confirmationText: "SpeedDate Created")
    }
}
