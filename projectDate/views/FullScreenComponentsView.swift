//
//  SwiftUIView.swift
//  HMSRoomKit
//
//  Created by DotZ3R0 on 4/20/25.
//

import SwiftUI

struct FullScreenComponentsView: View {
    @EnvironmentObject var videoViewModel: VideoViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var qaViewModel: QAViewModel
    
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
                try await qaViewModel.getQuestions()
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
                if !qaViewModel.questions.isEmpty {
                    Spacer()
                        .frame(height: 20)
                    
                    Text("\(qaViewModel.questions[0].body)")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    VStack{
                        if sliderValue > 0 {
                            Text("True")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        } else {
                            Text("False")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                        BiDirectionalSlider(value: $sliderValue)
                    }
                    .padding()
                    
                    Spacer()
                    
                    let config = AnimatedButton.Config(
                        title: transactionState.rawValue,
                        foregroundColor: .white,
                        background: transactionState.color,
                        symbolImage: transactionState.image
                    )
                    
                    AnimatedButton(config: config) {
                        let guid = UUID().uuidString
                        qaViewModel.answer.id = guid
                        qaViewModel.answer.answer = sliderValue > 0 ? "True" : "False"
                        qaViewModel.answer.profileId = profileViewModel.userProfile.id
                        qaViewModel.answer.questionId = qaViewModel.questions[0].id
                        
                        transactionState = .analyzing
                        try? await qaViewModel.saveAnswer()
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
        .environmentObject(QAViewModel())
}
