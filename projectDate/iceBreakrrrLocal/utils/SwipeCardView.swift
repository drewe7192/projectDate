//
//  CardView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import SwiftUI

struct SwipeCardView: View {
    @State
    private var translation: CGSize = .zero
    private var user: ProfileModel
    private var onRemove: (_ user: ProfileModel) -> Void
    
    private var threshold: CGFloat = 0.5
    
    init(user: ProfileModel, onRemove: @escaping (_ user: ProfileModel)
         -> Void) {
    self.user = user
        self.onRemove = onRemove
}
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 20) {
                Rectangle()
                .cornerRadius(10)
                .frame(width: geometry.size.width - 40,
                           height: geometry.size.height *                          0.65)
                Text("\(user.firstName) \( user.lastName)")
                .font(.title)
                .bold()
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 5)
            .animation(.spring())
            .offset(x: translation.width, y: 0)
            .rotationEffect(.degrees(
                    Double(self.translation.width /
                            geometry.size.width)
                            * 20), anchor: .bottom)
             .gesture(
                 DragGesture()
                 .onChanged {
                     translation = $0.translation
                  }.onEnded {
                    if $0.percentage(in: geometry) > threshold {
                        onRemove(self.user)
                    } else {
                        translation = .zero
                    }
                }
             )
        }
    }
}

extension DragGesture.Value {
    func percentage(in geometry: GeometryProxy) ->      CGFloat {
        abs(translation.width / geometry.size.width)
    }
}
