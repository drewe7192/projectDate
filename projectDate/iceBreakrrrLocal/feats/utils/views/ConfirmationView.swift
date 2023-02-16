//
//  ConfirmationView.swift
//  projectDate
//
//  Created by DotZ3R0 on 2/16/23.
//

import SwiftUI

struct ConfirmationView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        GeometryReader{ geoReader in
            ZStack{
                Color(.white)
                    .ignoresSafeArea()
                
                VStack{
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    
                    Button(action: {
                        viewRouter.currentPage = .homePage
                    }) {
                       Text("Route to HomePage")
                    }
                    .frame(width: 200, height: 100)
                    .background(.black)
                    .cornerRadius(20)
                    
                }
            }.position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY )
        }
       
      
       
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView()
    }
}
