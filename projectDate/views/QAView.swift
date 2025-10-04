//
//  QAView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 7/13/25.
//

import SwiftUI
import Combine
import Firebase

struct QAView: View {
    @State var timer: Cancellable?
    @State private var timeRemaining = 5
    @FocusState private var nameIsFocused: Bool
    @State private var currentUser: ProfileModel = emptyProfileModel
    @State private var updateQuestion: Bool = false
    @State private var showBlindChatTimerSheet: Bool = false
    @State private var showDeclineAlert: Bool = false
    @State private var showProfilePreview = false
    
    @EnvironmentObject var delegate: AppDelegate
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var qaViewModel: QAViewModel
    @EnvironmentObject var videoViewModel: VideoViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    
    let geometry: GeometryProxy
    let timer2 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 10) {
            // Connect Section: Profile info + Start BlindChat button
            connectSection(geometry: geometry)
            // QA question + Send button
            questionSection(geometry: geometry)
        }
        .task {
            do {
                try await getCurrentUsers()
                try await qaViewModel.getQuestions()
                startProfileRotation()
            } catch let error {
                print(error)
            }
        }
        .onChange(of: delegate.requestByProfile) { _, _ in
            videoViewModel.roomCode = ""
            viewRouter.currentPage = .requestPage
        }
        .onChange(of: delegate.isRequestAccepted) { _, newValue in
            Task {
                do {
                    if newValue == "true" {
                        let videoConfig = VideoConfigModel(role: .host, isScreenBlurred: true, isFullScreen: true)
                        showBlindChatTimerSheet = true
                        try await Task.sleep(for: .seconds(5))
                        viewRouter.currentPage = .videoPage(videoConfig: videoConfig)
                    } else if newValue == "false" {
                        showDeclineAlert = true
                    }
                } catch {}
            }
        }
        .alert("Sorry, user declined request", isPresented: $showDeclineAlert) {
            Button("OK", role: .cancel) { }
        }
        .onReceive(timer2) { _ in
            if showBlindChatTimerSheet {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    showBlindChatTimerSheet = false
                }
            }
        }
        .onChange(of: currentUser) { oldValue, newValue in
            if oldValue.id != newValue.id {
                updateQuestion.toggle()
            }
        }
        .sheet(isPresented: $showProfilePreview) {
            profilePreviewSheet(user: currentUser)
        }
    }
    
    // MARK: QA Widget Components
    private func connectSection(geometry: GeometryProxy) -> some View {
        HStack(spacing: 15) {
            quickChatProfileSection(geometry: geometry)
            Spacer()
            
            // ✅ Start BlindChat button
            Button(action: {
                print("Start BlindChat tapped!") // Debug
                showProfilePreview = true
            }) {
                Text("Start BlindChat")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: geometry.size.width * 0.2, maxHeight: geometry.size.height * 0.02)
                    .padding()
                    .background(currentUser.isActive && !currentUser.id.isEmpty ? Color.green : Color.gray)
                    .cornerRadius(12)
            }
            .disabled(!currentUser.isActive || currentUser.id.isEmpty)
            .opacity(currentUser.isActive && !currentUser.id.isEmpty ? 1 : 0.2)
        }
    }
    
    private func questionSection(geometry: GeometryProxy) -> some View {
        VStack{
            Text("\(qaViewModel.quickChatQuestion.body)")
                .bold()
                .font(.system(size: geometry.size.height * 0.025))
                .foregroundColor(.white)
                .padding()
            
            HStack(spacing: 5) {
                TextField("Type in answer", text: $qaViewModel.answer.body)
                    .onSubmit { startProfileRotation() }
                    .focused($nameIsFocused)
                    .foregroundColor(.gray)
                    .frame(width: geometry.size.width * 0.55, height: geometry.size.height * 0.02)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .textInputAutocapitalization(.never)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.primaryColor, lineWidth: 1)
                    )
                
                Button(action:  {
                    Task {
                        qaViewModel.currentQAWidgetState = .savingAnswer
                        try await qaViewModel.saveAnswer(profileId: profileViewModel.userProfile.id, askerProfileId: currentUser.id)
                        nameIsFocused = false
                        qaViewModel.currentQAWidgetState = .AnswerSaved
                        try await Task.sleep(for: .seconds(2))
                        qaViewModel.currentQAWidgetState = .inital
                        qaViewModel.answer.body = ""
                        profileViewModel.currentUsers.removeAll(where: {$0.id == currentUser.id})
                        qaViewModel.questions.removeAll(where: {$0.id == qaViewModel.quickChatQuestion.id})
                        if qaViewModel.questions.count < 2 {
                            try await qaViewModel.getQuestions()
                        }
                    }
                }) {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("tertiaryColor"), lineWidth: 2)
                        .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.055)
                        .overlay { Text("Send").foregroundColor(.white) }
                }
            }
        }
    }
    
    private func quickChatProfileSection(geometry: GeometryProxy) -> some View {
        HStack {
            Circle()
                .frame(width: geometry.size.width * 0.1)
                .overlay {
                    if !currentUser.profileImage.size.height.isZero {
                        Image(uiImage: currentUser.profileImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: geometry.size.width * 0.05, height: geometry.size.height * 0.03)
                            .foregroundColor(.black)
                    }
                }
            
            VStack(alignment: .leading){
                Text(currentUser.name).bold().font(.title3).foregroundColor(Color("tertiaryColor"))
                Text(currentUser.isActive ? "Active now" : "").foregroundColor(Color("tertiaryColor"))
            }
        }
    }
    
    // MARK: Profile Preview Sheet
    private func profilePreviewSheet(user: ProfileModel) -> some View {
        VStack(spacing: 20) {
            if !user.profileImage.size.height.isZero {
                Image(uiImage: user.profileImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)
            }
            
            Text(user.name).font(.title).bold()
            
            if let bio = user.bio, !bio.isEmpty {
                Text(bio).font(.body).multilineTextAlignment(.center).padding()
            }
            
            Text(user.isActive ? "Active now" : "Offline").foregroundColor(user.isActive ? .green : .gray)
            
            Spacer()
            
            HStack(spacing: 20) {
                Button("Decline") {
                    showProfilePreview = false
                    moveToNextProfile()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(12)
                .disabled(!currentUser.isActive || currentUser.id.isEmpty)
                .opacity(currentUser.isActive && !currentUser.id.isEmpty ? 1 : 0.2)
                
                Button("Accept") {
                    Task {
                        do {
                            qaViewModel.currentQAWidgetState = .sendingBCRequest
                            profileViewModel.participantProfile = user
                            try await sendRequestMessage(pickedUser: user)
                            qaViewModel.currentQAWidgetState = .BCRequestSent
                            showProfilePreview = false
                            moveToNextProfile()
                        } catch let error {
                            print(error)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
                .disabled(!currentUser.isActive || currentUser.id.isEmpty)
                .opacity(currentUser.isActive && !currentUser.id.isEmpty ? 1 : 0.2)
            }
        }
        .padding()
    }
    
    // MARK: Profile Rotation
    private func moveToNextProfile() {
        guard !profileViewModel.currentUsers.isEmpty else {
            currentUser = emptyProfileModel
            return
        }
        
        profileViewModel.currentUsers.removeAll(where: { $0.id == currentUser.id })
        
        if !profileViewModel.currentUsers.isEmpty {
            currentUser = profileViewModel.currentUsers.first!
            qaViewModel.quickChatQuestion = qaViewModel.questions.randomElement() ?? emptyQuestionModel
        } else {
            currentUser = emptyProfileModel
        }
    }
    
    private func startProfileRotation() {
        guard !profileViewModel.currentUsers.isEmpty else { return }
        var index = 0
        currentUser = profileViewModel.currentUsers[index]
        
        self.timer = Timer.publish(every: 4, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                guard !profileViewModel.currentUsers.isEmpty else {
                    currentUser = emptyProfileModel
                    return
                }
                index = (index + 1) % profileViewModel.currentUsers.count
                currentUser = profileViewModel.currentUsers[index]
                
                if updateQuestion {
                    qaViewModel.quickChatQuestion = qaViewModel.questions.randomElement() ?? emptyQuestionModel
                    updateQuestion.toggle()
                }
            }
    }
    
    // MARK: BlindChat Countdown
    private func blindChatCountdownSheet() -> some View {
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            VStack{
                Text("\(self.timeRemaining)").foregroundColor(.white).font(.largeTitle)
                Text("Until Chat starts").foregroundColor(.white).font(.largeTitle)
            }
        }
    }
    
    // MARK: Firebase Helpers
    private func sendRequestMessage(pickedUser: ProfileModel) async throws {
        do {
            let fcmToken = try await profileViewModel.GetFCMToken(userId: pickedUser.userId)
            profileViewModel.userProfile.userId = Auth.auth().currentUser?.uid as Any as! String
            _ = try await profileViewModel.callSendRequestNotification(fcmToken: fcmToken, requestByProfile: profileViewModel.userProfile)
        } catch {
            throw error
        }
    }
    
    private func getCurrentUsers() async throws {
        try await profileViewModel.GetCurrentUsers()
    }
}

enum QAWidgetState {
    case inital, savingAnswer, AnswerSaved, sendingBCRequest, BCRequestSent
}

