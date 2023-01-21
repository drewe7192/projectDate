//
//  CardView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import SwiftUI
struct Contact: Identifiable {
    let id = UUID()
    let name: String
}


struct SwipeCardView: View {
    
    var contacts = [
          Contact(name: "John"),
          Contact(name: "Alice"),
          Contact(name: "Bob")
      ]
      // 2
      @State private var multiSelection = Set<UUID>()
    
    var colors = ["Red", "Green", "Blue", "Tartan"]
       @State private var selectedColor = "Red"
    
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
                ZStack{
                    
                    Rectangle()
                        .foregroundColor(.white)
                    .cornerRadius(40)
                    .frame(width: geometry.size.width - 50,
                               height: geometry.size.height * 0.35)
                    
                    VStack{
                        Text("What’s Something You’re Proud of?")
                            .font(.system(size: 30))
               
                              VStack {
                                  Picker("Please choose a color", selection: $selectedColor) {
                                      ForEach(colors, id: \.self) {
                                          Text($0)
                                      }
                                  }
                                  Text("You selected: \(selectedColor)")
                              }

                    }
                }
            
                
//                Text("\(user.firstName) \( user.lastName)")
//                .font(.title)
//                .bold()
                Divider()
                Text("Upcoming Event")
                
                Text("SpeedDate Kickball")
                    .font(.title2)
                .bold()
                .padding(5)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(.blue, lineWidth: 4))
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(40)
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

struct SwipeCardView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeCardView(user: MockService.profileSampleData, onRemove: {_ in})
    }
}
