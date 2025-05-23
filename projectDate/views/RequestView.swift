//
//  RequestView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 5/23/25.
//

import SwiftUI

struct RequestView: View {
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            
            VStack{
                Text("Drew")
                    .bold()
                    .font(.system(size: 60))
                    .foregroundColor(.black)
                
                Text(" Requested a BlindDate!")
                    .font(.system(size: 60))
                    .foregroundColor(.black)
                
                Button(action: {
        
                }) {
                    Text("Accept")
                        .foregroundColor(.white)
                        .frame(width: 350, height: 60)
                        .background(Color.mainGrey)
                        .cornerRadius(40)
                }
                
                Button(action: {
        
                }) {
                    Text("Decline")
                        .foregroundColor(.white)
                        .frame(width: 350, height: 60)
                        .background(Color.mainGrey)
                        .cornerRadius(40)
                }
            }
        }
    }
}

#Preview {
    RequestView()
}
