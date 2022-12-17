//
//  sdHomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 11/26/22.
//

import SwiftUI

struct sdHomeView: View {
    var body: some View {
            VStack{
                
                ForEach(0..<5){ index in
                    sdCardView()
                }
                
                info
                
                //button
                NavigationLink(destination: FacetimeView(viewModel: .init()), label: {
                    Text("Lets Date!")
                        .font(.title.bold())
                        .frame(width: 350, height: 50)
                        .background(.white)
                        .foregroundColor(.gray)
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20)
                            .stroke(.black, lineWidth: 2))
                })
            }
    }
    
    private var info: some View {
        VStack{
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when Please be polite, please be kindd")
                .multilineTextAlignment(.center)
                .padding(.top,20)
            
            
            Text("Dont forget to")
                .multilineTextAlignment(.center)
                .padding(.top,20)
            
            Text("Have Fun!")
                .fontWeight(.bold)
                .font(.system(size: 40))
        }
    }
}

struct sdHomeView_Previews: PreviewProvider {
    static var previews: some View {
        sdHomeView()
    }
}
