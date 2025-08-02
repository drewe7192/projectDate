//
//  CustomIntroVIew.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 8/1/25.
//

import SwiftUI

struct CustomIntroView: View {
    @State private var selectedItem: WalkthroughItem = walkthroughItems.first!
    @State private var introItems: [WalkthroughItem] = walkthroughItems
    @State private var activeIndex: Int = 0
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        ZStack {
            Color.primaryColor
                .ignoresSafeArea()
         
            VStack(spacing: 0) {
                /// Back Button
                Button {
                    updateItem(isForward: false)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3.bold())
                        .foregroundStyle(.green.gradient)
                        .contentShape(.rect)
                }
                .padding(15)
                .frame(maxWidth: .infinity, alignment: .leading)
                /// Only Visible from second item
                .opacity(selectedItem.id != introItems.first?.id ? 1 : 0)
                
                ZStack {
                    /// Animated Icons
                    ForEach(introItems) { item in
                        AnimatedIconView(item)
                    }
                }
                .frame(height: 250)
                .frame(maxHeight: .infinity)
                
                VStack(spacing: 6) {
                    /// Progress Indicator View
                    HStack(spacing: 4) {
                        ForEach(introItems) { item in
                            Capsule()
                                .fill(selectedItem.id == item.id ? Color.white : .gray)
                                .frame(width: selectedItem.id == item.id ? 25: 4, height: 4)
                        }
                    }
                    .padding(.bottom, 15)
                    
                    Text(selectedItem.title)
                        .font(.title.bold())
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                    
                    Text(selectedItem.description)
                        .font(.system(size: 15))
                        .foregroundStyle(.gray)
                    
                    /// Next/Continue Button
                    Button {
                        updateItem(isForward: true)
                        if selectedItem.id == introItems.last?.id {
                            viewRouter.currentPage = .homePage
                        }
                    } label: {
                        Text(selectedItem.id == introItems.last?.id ? "Continue" : "Next")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .contentTransition(.numericText())
                            .frame(width: 250)
                            .padding(.vertical, 12)
                            .background(.green.gradient, in: .capsule)
                    }
                    .padding(.top, 25)
                }
                .multilineTextAlignment(.center)
                .frame(width: 300)
                .frame(maxHeight: .infinity)
            }
        }
    }
    
    @ViewBuilder
    func AnimatedIconView(_ item: WalkthroughItem) -> some View {
        let isSelected = selectedItem.id == item.id
        
        Image(systemName: item.image)
            .font(.system(size: 80))
            .foregroundStyle(.white.shadow(.drop(radius: 10)))
            .blendMode(.overlay)
            .frame(width: 120, height: 120)
            .background(.green.gradient, in: .rect(cornerRadius: 32))
            .background {
                RoundedRectangle(cornerRadius: 35)
                    .fill(.background)
                    .shadow(color: .primary.opacity(0.2), radius: 1, x: 1, y: 1)
                    .shadow(color: .primary.opacity(0.2), radius: 1, x: -1, y: -1)
                    .padding(-3)
                    .opacity(selectedItem.id == item.id ? 1 : 0)
                
            }
        /// Resetting Rotation
            .rotationEffect(.init(degrees: -item.rotation))
            .scaleEffect(isSelected ? 1.1 : item.scale, anchor: item.anchor)
            .offset(x: item.offset)
            .rotationEffect(.init(degrees: item.rotation))
        /// Placing active icon at the top
            .zIndex(isSelected ? 2 : item.zindex)
    }
    
    /// Shift active icon to the center when continue or back button is pressed
    func updateItem(isForward: Bool) {
        /// backwards interaction
        guard isForward ? activeIndex != introItems.count - 1 : activeIndex != 0 else { return }
        var fromIndex: Int
        var extraOffset: CGFloat
        /// To Index
        if isForward {
            activeIndex += 1
        } else {
            activeIndex -= 1
        }
  
        /// From Index
        if isForward {
            fromIndex = activeIndex - 1
            extraOffset = introItems[activeIndex].extraOffset
        } else {
            extraOffset = introItems[activeIndex].extraOffset
            fromIndex = activeIndex + 1
        }
     
        /// Resetting Index
        for index in introItems.indices {
            introItems[index].zindex = 0
        }
        
        Task { [fromIndex, extraOffset] in
            /// Shifting from and to icon locations
            withAnimation(.bouncy(duration: 1)) {
                introItems[fromIndex].scale = introItems[activeIndex].scale
                introItems[fromIndex].rotation = introItems[activeIndex].rotation
                introItems[fromIndex].anchor = introItems[activeIndex].anchor
                introItems[fromIndex].offset = introItems[activeIndex].offset
                
                introItems[activeIndex].offset = extraOffset
                
                
                introItems[fromIndex].zindex = 1
            }
            try? await Task.sleep(for: .seconds(0.1))
            
            withAnimation(.bouncy(duration: 0.9)) {
                /// To location is always at the center
                introItems[activeIndex].scale = 1
                introItems[activeIndex].rotation = .zero
                introItems[activeIndex].anchor = .center
                introItems[activeIndex].offset = .zero
                /// Updating selected Item
                selectedItem = introItems[activeIndex]
                
            }
        }
    }
}

#Preview {
    CustomIntroView()
        .environmentObject(ViewRouter())
}
