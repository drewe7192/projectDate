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
    @ObservedObject private var viewModel = EventViewModel()
    @State private var selectedColor = ""
    
    @State
    private var translation: CGSize = .zero
    private var question: QuestionModel
    private var onRemove: (_ question: QuestionModel) -> Void
    private var threshold: CGFloat = 0.5
    
    init(question: QuestionModel, onRemove: @escaping (_ question: QuestionModel)
         -> Void) {
        self.question = question
        self.onRemove = onRemove
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 20) {
                ZStack{
                    Rectangle()
                        .foregroundColor(Color("IceBreakrrrPink"))
                        .cornerRadius(40)
                        .frame(width: geometry.size.width - 40,
                               height: geometry.size.height * 0.45)
                    
                    VStack{
                        Text("\(question.question)")
                            .font(.custom("Superclarendon", size: 30))
                            .foregroundColor(.white)
                        Spacer()
                            .frame(height: 40)
                        VStack {
                            Picker("", selection: $selectedColor) {
                                ForEach(question.choices, id: \.self) { choice in
                                    Text("\(choice)")
                                }
                              
                            }
                        }
                    }
                }
                
                Divider()
                
//                Text("Upcoming Event")
//                NavigationLink(destination: EventInfoView()){
//                    Text("\(viewModel.events.first!.title)")
//                        .foregroundColor(.black)
//                        .font(.title2)
//                        .bold()
//                        .padding(7)
//                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.blue, lineWidth: 4))
//                }
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
                            onRemove(self.question)
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
        SwipeCardView(question: MockService.questionsSampleData.first!, onRemove: {_ in})
    }
}
