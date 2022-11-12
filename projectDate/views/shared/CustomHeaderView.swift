//
//  CustomHeaderView.swift
//  projectDate
//
//  Created by dotZ3R0 on 11/10/22.
//

import SwiftUI

struct CustomHeaderView: View {
    var body: some View {
        ZStack{
            Text("")
                .frame(width: 200, height: 1000)
                .background(Color.white)
                .cornerRadius(65, corners: [.topRight])
                .padding([.top, .trailing],200)
            
            
            Text("")
                .frame(width: 200, height: 1000)
                .background(Color.blue)
                .cornerRadius(65, corners: [.topLeft])
                .padding([.top, .leading],200)
            
            
            Text("")
                .frame(width: 400, height: 1040)
                .background(Color.white)
                .cornerRadius(65, corners: [.topRight])
                .padding([.top],350)
            
            
            Text("")
                .frame(width: 400, height: 160)
                .background(Color.blue)
                .cornerRadius(65, corners: [.topLeft, .topRight, .bottomLeft])
                .padding([.bottom],850)
            
        }
    }
}

struct CustomHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CustomHeaderView()
    }
}
