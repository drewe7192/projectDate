//
//  sdInfoCardView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/10/23.
//

import SwiftUI

struct sdInfoCardView: View {
    var body: some View {
        ZStack{
//            Text("")
//                .frame(width: 350, height: 250, alignment: .bottom)
//                .background(.gray)
//                .foregroundColor(.gray)
//                .cornerRadius(60)
            
            VStack{
                Text("Lorem Ipsum is simply dummy fds fdsfsd dfs fds fds fdsfdsfdsfs fdsbvfdgvdf text Lorem Ipsum is simply dummy fds fdsfsd dfs fds fds fdsfdsfdsfs fdsbvfdgvdf textLorem Ipsum is simply dummy fds fdsfsd dfs fds fds fdsfdsfdsfs fdsbvfdgvdf text")
                    .multilineTextAlignment(.center)
                    .padding(.top,20)
                
                
                Text("Dont forget to")
                    .multilineTextAlignment(.center)
                    .padding(.top,20)
                
                Text("Have Fun!")
                    .fontWeight(.bold)
                    .font(.system(size: 40))
                Text("Little THings/Hindge Prompts could go in here")
                    .fontWeight(.bold)
                    .font(.system(size: 20))
            }
            .padding(.horizontal, 40)
            .frame(maxWidth: 500, maxHeight: 300)
        }
  
    }
}

struct sdInfoCardView_Previews: PreviewProvider {
    static var previews: some View {
        sdInfoCardView()
    }
}
