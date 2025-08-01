//
//  SwiftUIView.swift
//  HMSRoomKit
//
//  Created by DotZ3R0 on 4/20/25.
//

import SwiftUI
import Firebase
import HMSRoomModels

struct FullScreenComponentsView: View {
    @State private var timeRemaining = 15
    @State private var showQuestion: Bool = false
    @State private var transactionState: TransactionState = .idle
    @State private var showTimer: Bool = true
    @State private var displaySubmitButton: Bool = false
    @State private var currentChoice: ChoiceModel = emptyChoiceModel
    
    @EnvironmentObject var videoViewModel: VideoViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var qaViewModel: QAViewModel
    @EnvironmentObject var delegate: AppDelegate
    @EnvironmentObject var viewRouter: ViewRouter
    
    @Binding var isMicMuted: Bool
    
    let role: RoleType
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            if self.showTimer {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.blue, lineWidth: 2)
                    .frame(width: 210, height: 100)
                    .overlay {
                        VStack(alignment: .center) {
                            Text("Chat it up! You got ")
                                .font(.title3)
                            Text("\(self.timeRemaining)")
                                .font(.title)
                            Text("seconds left")
                                .font(.title3)
                        }
                        .padding()
                    }
            } else if self.showQuestion {
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
            
            if timeRemaining >= 10 {
                self.showTimer = true
            }
            
            if timeRemaining == 0 {
                self.showTimer = false
                self.showQuestion = true
                self.isMicMuted = true
            }
        }
        .onChange(of: delegate.hostAnswerBlindDate) { oldValue, newValue in
            Task {
                if !newValue.isEmpty {
                    do {
                        if !qaViewModel.answer.body.isEmpty {
                            try await compareAnswers(role: RoleType.guest, hostAnswer: newValue, guestAnswer: qaViewModel.answer.body)
                        } else {
                            transactionState = .waitingForResponse
                        }
                        
                    } catch {
                        // HANDLE ERROR
                    }
                }
            }
        }
        .onChange(of: delegate.guestAnswerBlindDate) { oldValue, newValue in
            Task {
                do {
                    if !newValue.isEmpty {
                        if !qaViewModel.answer.body.isEmpty {
                            try await compareAnswers(role: RoleType.host, hostAnswer: qaViewModel.answer.body, guestAnswer: newValue)
                        } else {
                            transactionState = .waitingForResponse
                        }
                    }
                    
                } catch {
                    // HANDLE ERROR
                }
            }
        }
    }
    
    private func questionView() -> some View {
        ZStack{
            Color.primaryColor
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                Text("\(qaViewModel.questions[0].body)")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                displayChoices()
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
                    qaViewModel.answer.body = self.currentChoice.text
                    qaViewModel.answer.profileId = profileViewModel.userProfile.id
                    qaViewModel.answer.questionId = qaViewModel.questions[0].id
                    
                    /// Fires Ontap of button
                    Task {
                        do {
                            if !delegate.guestAnswerBlindDate.isEmpty || !delegate.hostAnswerBlindDate.isEmpty {
                                transactionState = .analyzingAnswers
                                
                                try await compareAnswers(role: role, hostAnswer: !delegate.hostAnswerBlindDate.isEmpty ? delegate.hostAnswerBlindDate : qaViewModel.answer.body, guestAnswer: !delegate.guestAnswerBlindDate.isEmpty ? delegate.guestAnswerBlindDate : qaViewModel.answer.body)
                                
                            } else {
                                transactionState = .answerSubmitted
                            }
                            
                            try await processingAnswer(config: config)
                        } catch {
                            // HANDLE ERROR
                        }
                    }
                }
                .opacity(!displaySubmitButton ? 0.5 : 1)
                .disabled(!displaySubmitButton)
            }
        }
    }
    
    private func processingAnswer (config: AnimatedButton.Config) async throws {
        if role == RoleType.host {
            Task {
                do {
                    let fcmToken = try await profileViewModel.GetFCMToken(userId: !profileViewModel.participantProfile.userId.isEmpty ? profileViewModel.participantProfile.userId : Auth.auth().currentUser?.uid ?? "")
                    
                    _ = try await qaViewModel.sendAnswerNotification(fcmToken: fcmToken, role: RoleType.host, answer: self.currentChoice.text)
                } catch {
                    // HANDLE ERROR
                }
            }
        }
        else {
            Task {
                do {
                    let fcmToken = try await profileViewModel.GetFCMToken(userId: !profileViewModel.participantProfile.userId.isEmpty ? profileViewModel.participantProfile.userId : Auth.auth().currentUser?.uid ?? "")
                    
                    _ = try await qaViewModel.sendAnswerNotification(fcmToken: fcmToken, role: RoleType.guest, answer: self.currentChoice.text)
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
                transactionState = hostAnswer == guestAnswer ? .success : .failed
                try await Task.sleep(for: .seconds(3))
                
                if transactionState == .success {
                    /// continue videoChat
                    showQuestion.toggle()
                    
                    qaViewModel.answer.body = ""
                    delegate.guestAnswerBlindDate = ""
                    delegate.hostAnswerBlindDate = ""
                    timeRemaining = 12
                    self.isMicMuted = false
                    qaViewModel.questions.removeFirst()
                    
                    if qaViewModel.questions.count < 5 {
                        try await qaViewModel.getQuestions()
                    }
                    
                } else if transactionState == .failed {
                    /// leave session
                    viewRouter.currentPage = .homePage
                    videoViewModel.roomCode = ""
                }
                transactionState = .idle
            } catch {
                /// HANDLE ERRORS
            }
        }
    }
    
    private func displayChoices() -> some View {
        VStack{
            ForEach($qaViewModel.questions[0].choices, id: \.self) { $choice in
                RoundedRectangle(cornerRadius: 20)
                    .stroke(choice.isSelected ? .green : .white, lineWidth: 2)
                    .frame(width: 350, height: 70)
                    .overlay {
                        VStack(alignment: .center) {
                            Text("\(choice.text)")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                    }
                    .onTapGesture {
                        for i in qaViewModel.questions[0].choices.indices {
                            qaViewModel.questions[0].choices[i].isSelected = false
                        }
                        
                        choice.isSelected.toggle()
                        self.currentChoice = choice
                        
                        if qaViewModel.questions[0].choices.contains(where: {$0.isSelected == true}) {
                            displaySubmitButton = true
                        } else {
                            displaySubmitButton = false
                        }
                    }
                    .padding()
            }
        }
    }
}

#Preview {
    FullScreenComponentsView(isMicMuted: .constant(false), role: RoleType.host)
        .environmentObject(VideoViewModel())
        .environmentObject(QAViewModel())
        .environmentObject(AppDelegate())
        .environmentObject(ProfileViewModel())
}
