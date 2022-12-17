//
//  CustomSegmentedControl.swift
//  projectDate
//
//  Created by DotZ3R0 on 11/20/22.
//

import SwiftUI

struct CustomSegmentedControl: View {
    @Binding var selectedTab: Int
    var options: [String]
    let color = Color.red
    
    var body: some View {
        
        HStack(spacing: 0){
            ForEach(options.indices, id: \.self) { index in
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                    
                    Rectangle()
                        .fill(Color.white)
                        .cornerRadius(20)
                        .padding(2)
                        .opacity(selectedTab == index ? 1 : 0.01)
                        .onTapGesture {
                            withAnimation(.interactiveSpring()) {
                                selectedTab = index
                            }
                        }
                }
                .overlay(
                Text(options[index])
                    .foregroundColor(selectedTab == index ? color : Color.black)
                )
            }
        }
        .frame(height: 40)
        .cornerRadius(20)
    }
}

struct CustomSegmentedControl_Previews: PreviewProvider {
    static var previews: some View {
        CustomSegmentedControl(selectedTab: .constant(0), options: ["First","Second","Third"])
    }
}
