//
//  TextShimmer.swift
//  projectDate
//
//  Created by DotZ3R0 on 6/3/23.
//

import SwiftUI

struct TextShimmer: View {
    var text: String
    @State private var animationn = false
    
    var body: some View {
        ZStack{
            Text(text)
                .font(.system(size: 75, weight: .bold))
                .foregroundColor(Color.black.opacity(0.25))
            
            HStack(spacing: 0){
                ForEach(0..<text.count,id: \.self){index in
                    Text(String(text[text.index(text.startIndex, offsetBy: index)]))
                        .font(.system(size: 75, weight: .bold))
                        .foregroundColor(randomColor())
                }
            }
            .mask(
            Rectangle()
                .fill(
                    LinearGradient(gradient: .init(colors: [Color.white.opacity(0.5),Color.white,Color.white.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                )
                .rotationEffect(.init(degrees: 70))
                .padding(20)
                .offset(x: -250)
                .offset(x: animationn ? 500 : 0)
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 2)
                    .repeatForever(autoreverses: false)){
                        animationn.toggle()
                    }
            }
        }
    }
    
    func randomColor()->Color{
        let color = UIColor(red: 1, green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
        
        return Color(color)
    }
}

struct TextShimmer_Previews: PreviewProvider {
    static var previews: some View {
        TextShimmer(text: "Test")
    }
}
