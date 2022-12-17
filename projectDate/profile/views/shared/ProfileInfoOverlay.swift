//
//  ProfileInfoOverlay.swift
//  projectDate
//
//  Created by DotZ3R0 on 11/21/22.
//

import SwiftUI

struct ProfileInfoOverlay: View {
    var body: some View {
        ZStack{
        
            VStack(alignment: .leading){
                    Text("Jane Jane")
                        .font(.title)
                        .padding()
                
                ScrollView{
                    VStack{
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exert")
                            .padding(.bottom)
                        
                        Text("Interests")
                            .font(.title2)
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exert")
                    }
                }
              
            }
            .frame(width: 350, height: 200)
            .background(.gray)
            .cornerRadius(40)
            .opacity(0.5)
            .padding()
            
        }
    }
}



struct ProfileInfoOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInfoOverlay()
    }
}
