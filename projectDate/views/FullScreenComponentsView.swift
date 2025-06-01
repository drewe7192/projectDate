//
//  SwiftUIView.swift
//  HMSRoomKit
//
//  Created by DotZ3R0 on 4/20/25.
//

import SwiftUI
import Firebase

struct FullScreenComponentsView: View {
    let role: RoleType
    @EnvironmentObject var videoViewModel: VideoViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var qaViewModel: QAViewModel
    @EnvironmentObject var delegate: AppDelegate
    
    /// there's a 5 sec delay once user taps checkmark
    @State private var timeRemaining = 15
    @State private var question: String = "testing"
    @State private var answer: String = ""
    @State private var questionNumber: Int = 0
    @State private var showSheet: Bool = false
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
        .onChange(of: delegate.hostAnswerBlindDate) { oldValue, newValue in
            Task {
                do {
                    if qaViewModel.answer.answer != "" {
                        try await compareAnswers(role: RoleType.guest, hostAnswer: newValue, guestAnswer: self.answer)
                        
                        /// clear if dirty
                        delegate.hostAnswerBlindDate = ""
                    } else {
                        transactionState = .waitingForResponse
                    }
                    
                } catch {
                    // HANDLE ERROR
                }
            }
        }
        .onChange(of: delegate.guestAnswerBlindDate) { oldValue, newValue in
            Task {
                do {
                    if qaViewModel.answer.answer != "" {
                        try await compareAnswers(role: RoleType.host, hostAnswer: self.answer, guestAnswer: newValue)
                        
                        /// clear if dirty
                        delegate.guestAnswerBlindDate = ""
                    } else {
                        transactionState = .waitingForResponse
                    }
                    
                    
                } catch {
                    // HANDLE ERROR
                }
            }
        }
    }
    
    private func questionView() -> some View {
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
                        
                        Task {
                            do {
                               // self.answer = qaViewModel.answer.answer
                                
                                if delegate.guestAnswerBlindDate != "" || delegate.hostAnswerBlindDate != "" {
                                    
                                    transactionState = .analyzingAnswers
                                    
                                    try await compareAnswers(role: role, hostAnswer: delegate.hostAnswerBlindDate != "" ? delegate.hostAnswerBlindDate : self.answer, guestAnswer: delegate.guestAnswerBlindDate != "" ? delegate.guestAnswerBlindDate : self.answer)
                                    
                                    /// clear if dirty
                                    delegate.hostAnswerBlindDate = ""
                                    delegate.guestAnswerBlindDate = ""
                                } else {
                                    transactionState = .answerSubmitted
                                }
                                
                                try await processingAnswer(config: config)
                            } catch {
                                // HANDLE ERROR
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func processingAnswer (config: AnimatedButton.Config) async throws {
        if role == RoleType.host {
            Task {
                do {
                    let fcmToken = try await profileViewModel.GetFCMToken(userId: profileViewModel.participantProfile.id != "" ? profileViewModel.participantProfile.userId : Auth.auth().currentUser?.uid ?? "")
                    
                    _ = try await qaViewModel.sendAnswerNotification(fcmToken: fcmToken, role: RoleType.host, answer: "HOSTANSWERED")
                } catch {
                    // HANDLE ERROR
                }
            }
        }
        else {
            Task {
                do {
                    let fcmToken = try await profileViewModel.GetFCMToken(userId: profileViewModel.participantProfile.id != "" ? profileViewModel.participantProfile.userId : Auth.auth().currentUser?.uid ?? "")
                    
                    _ = try await qaViewModel.sendAnswerNotification(fcmToken: fcmToken, role: RoleType.guest, answer: "GUESTANSWERED")
                } catch {
                    // HANDLE ERROR
                }
            }
        }
    }
    
    private func compareAnswers(role: RoleType, hostAnswer: String, guestAnswer: String) async throws {
        Task {
            do {
                transactionState = .analyzingAnswers
                var isAnswerMatch = true
                transactionState = isAnswerMatch ? .success : .failed
                try await Task.sleep(for: .seconds(2))
                transactionState = .idle
            } catch {
                
            }
        }
    }
}

#Preview {
    FullScreenComponentsView(role: RoleType.host)
        .environmentObject(VideoViewModel())
        .environmentObject(QAViewModel())
        .environmentObject(AppDelegate())
    
}
