//
//  SwiftUIView.swift
//  HMSRoomKit
//
//  Created by DotZ3R0 on 4/20/25.
//

import SwiftUI

struct FullScreenComponentsView: View {
    @EnvironmentObject var videoViewModel: VideoViewModel
    
    @State private var timeRemaining = 15
    @State private var question: String = "testing"
    @State private var answer: String = ""
    @State private var questionNumber: Int = 0
    @State private var showSheet: Bool = true
    @State private var sliderValue: Double = 0
    @State private var transactionState: TransactionState = .idle
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            if showSheet {
                questionView()
            }
        }
        .task {
            do {
                try await videoViewModel.getQuestions()
            } catch {
                // HANDLE ERROR
            }
        }
        .onReceive(timer) { time in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
            
            if timeRemaining == 0 {
                self.showSheet = true
            }
        }
        .onChange(of: self.answer) { value, _ in
            
            self.questionNumber = self.questionNumber + 1
            
            //            self.question = self.littleThingsList[self.questionNumber]
            
            //clear if dirty
            self.answer = ""
        }
    }
    
    func questionView() -> some View {
        ZStack{
            Color.blue
                .ignoresSafeArea()
            VStack{
                if !videoViewModel.questions.isEmpty {
                    Spacer()
                        .frame(height: 20)
                    
                    Text("\(videoViewModel.questions[0].body)")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    VStack{
                        if sliderValue > 0 {
                            Text("True")
                                .font(.system(size: 20))
                        } else {
                            Text("False")
                                .font(.system(size: 20))
                        }
                        BiDirectionalSlider(value: $sliderValue)
                    }
                    .padding()
                    
                    Spacer()
                    
                    //                    RoundedRectangle(cornerRadius: 25)
                    //                        .fill(.gray)
                    //                        .frame(width: 350, height: 80)
                    //                        .overlay{
                    //                            Text("Send")
                    //                                .font(.system(size: 20))
                    //                        }
                    
                    let config = AnimatedButton.Config(
                        title: transactionState.rawValue,
                        foregroundColor: .white,
                        background: transactionState.color,
                        symbolImage: transactionState.image
                    )
                    
                    AnimatedButton(config: config) {
                        transactionState = .analyzing
                        try? await Task.sleep(for: .seconds(3))
                        transactionState = .processing
                        try? await Task.sleep(for: .seconds(3))
                        transactionState = .failed
                        try? await Task.sleep(for: .seconds(1))
                        transactionState = .idle
                        
                    }
                }
            }
        }
    }
}

#Preview {
    FullScreenComponentsView()
        .environmentObject(VideoViewModel())
}
