//
//  FailedView.swift
//  projectDate
//
//  Created by DotZ3R0 on 2/19/23.
//

import SwiftUI

struct FailedView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        GeometryReader{ geoReader in
            ZStack{
                Color.mainBlack
                    .ignoresSafeArea()
                
                VStack(spacing: 20){
              
                    
                    Image("confirmationX")
                        .resizable()
                        .frame(width: 300, height: 300)
                    
                    Text("Oops!")
                        .bold()
                        .font(.system(size: geoReader.size.height * 0.04))
                        .foregroundColor(.white)
                    
                    Text("Something went wrong.")
                        .foregroundColor(.white)
                    
                    Button(action: {
                        viewRouter.currentPage = .homePage
                    }) {
                       Text("Return Home and try again")
                            .bold()
                            .frame(width: 300, height: 70)
                            .background(.red)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(radius: 8, x: 10, y:10)
                    }
                }
            }.position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY )
        }
    }
}

struct FailedView_Previews: PreviewProvider {
    static var previews: some View {
        FailedView()
    }
}
