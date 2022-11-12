//
//  GamesView.swift
//  projectDate
//
//  Created by dotZ3R0 on 11/10/22.
//

import SwiftUI

struct GamesView: View {
    var body: some View {
        NavigationView{
            ZStack{
                CustomHeaderView()
                VStack{
                    ScrollView{
                        VStack(spacing: 20){
                            ForEach(0..<10){
                                Text("Item \($0)")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                                    .frame(width: 300, height: 80)
                                    .background(.red)
                                    .cornerRadius(30)
                            }
                        }
                    }.padding(.top,400)
                    
                }
            }
            .navigationTitle("Match Games")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    
    }
}

struct GamesView_Previews: PreviewProvider {
    static var previews: some View {
        GamesView()
    }
}
