//
//  HomeView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 2/18/25.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @State private var videoConfig: VideoConfigModel = emptyVideoConfig
    @State private var isHeartSelected: Bool = false
    @State private var showingNewAnswersSheet = false
    @State private var selectedOptions: Set<String> = []
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var qaViewModel: QAViewModel
    @EnvironmentObject var videoViewModel: VideoViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel

    @Binding var selectedTab: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AnimatedGradientBackground()
                    .ignoresSafeArea()
                
                VStack{
                    header(geometry: geometry)
                        .padding(.bottom)
                    
                    GlassContainer {
                        QAView(geometry: geometry)
                    }
                    .frame(height: geometry.size.height * 0.3)
                    
                    Spacer()
                        .frame(height: geometry.size.height * 0.04)
                    
                    videoSection(geometry: geometry)
                    
                    Spacer()
                    
                    GlassContainer {
                        VStack{
                            Text("Upcoming SpeedDate")
                                .foregroundStyle(.white)
                            
                            Text("Sunday evening 8pm")
                                .foregroundStyle(.white)
                        }
                     
                    }
                    .frame(height: geometry.size.height * 0.1)
                    
                    Spacer()
                }
            }
            .task {
                do {
                    /// get profile and launch video
                    try await profileViewModel.GetUserProfile()
                    try await profileViewModel.getFileFromStorage(profileId: profileViewModel.userProfile.id)
                    
                    videoViewModel.roomCode = profileViewModel.userProfile.roomCode
                    
                    /// update user app status to active
                    try await profileViewModel.UpdateActivityStatus(isActive: true)
                    
                    /// check for newly answered questions
                    try await qaViewModel.getRecentQA(profileId: profileViewModel.userProfile.id)
                } catch {
                    print("Error getting userProfile:\(error)")
                }
            }
            .onChange(of: qaViewModel.recentQAs) { oldValue, newValue in
                if !newValue.isEmpty {
                    showingNewAnswersSheet = true
                }
            }
            .sheet(isPresented: $showingNewAnswersSheet) {
                newAnswersSheet()
            }
            .sheet(isPresented: $profileViewModel.showingQuestionSelectSheet) {
                PickNewQuestionsSheet(
                    options: qaViewModel.newUserQuestions,
                    selectedOptions: $selectedOptions,
                    onSubmit: {
                        profileViewModel.showingQuestionSelectSheet = false
                    }
                )
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private func header(geometry: GeometryProxy) -> some View {
        HStack{
            Circle()
                .frame(width: geometry.size.width * 0.08)
                .overlay {
                    if !profileViewModel.userProfile.profileImage.size.height.isZero {
                        Circle()
                            .overlay(
                                Image(uiImage: profileViewModel.userProfile.profileImage)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                            )
                            .frame(width: geometry.size.width * 0.09)
                        
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: geometry.size.width * 0.01, height: geometry.size.height * 0.01)
                    }
                }
                .padding(.leading)
                .onTapGesture {
                    selectedTab = 1
                }
            
            Spacer()
            
            Text("LittleBigThings")
                .font(.custom("Copperplate", size: geometry.size.height * 0.03))
                .foregroundColor(Color("tertiaryColor"))
                .bold()
            
            Image("logo")
                .resizable()
                .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1)
            
            Spacer()
            
            Button(action : {
                viewRouter.currentPage = .notificationsPage
            }){
                Image(systemName: "bell.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * 0.07)
                    .foregroundColor(Color("tertiaryColor"))
                    .padding(.horizontal)
                    .clipShape(Circle())
            }
        }
    }
    
    private func videoSection(geometry: GeometryProxy) -> some View {
        VStack {
            if !videoViewModel.roomCode.isEmpty {
                VideoView(videoConfig: videoConfig)
            }
            else {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.primaryColor)
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.4)
                    .overlay {
                        VStack {
                            ProgressView {
                                
                            }
                            .scaleEffect(x: 4, y: 4, anchor: .center)
                            .padding(.bottom)
                            
                            Text("Joining room...")
                                .font(.system(size: 25))
                                .bold()
                                .foregroundColor(.black)
                        }
                    }
            }
        }
    }
    
    private func events(geometry: GeometryProxy) -> some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    ForEach(0...4, id: \.self) {_ in
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.blue, lineWidth: 2)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.15)
                            .overlay{
                                HStack{
                                    HStack(spacing: -15) {
                                        ForEach(0...4, id: \.self) { _ in
                                            HStack(spacing: 0) {
                                                Circle()
                                                    .overlay {
                                                        Image(systemName: "person.fill")
                                                            .resizable()
                                                            .frame(width: geometry.size.width * 0.03, height: geometry.size.height * 0.02)
                                                            .foregroundColor(.black)
                                                    }
                                                    .foregroundColor(.gray)
                                                    .frame(width: geometry.size.width * 0.08, height: geometry.size.height * 0.08)
                                            }
                                        }
                                    }
                                    
                                    Text("Meet 1")
                                        .foregroundColor(Color("tertiaryColor"))
                                        .font(.system(size: geometry.size.height * 0.03))
                                        .bold()
                                        .padding(.bottom,5)
                                    
                                    HStack{
                                        Text("3/3/25 @4pm")
                                            .foregroundColor(Color("tertiaryColor"))
                                            .font(.system(size: geometry.size.height * 0.015))
                                    }
                                    .padding(.bottom)
                                }
                                .padding(5)
                                
                            }
                            .padding(5)
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0)
                                    .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                    .blur(radius: phase.isIdentity ? 0 : 10)
                            }
                    }
                }
            }
        }
        .padding(.bottom)
    }
    
    private func newAnswersSheet() -> some View {
        ZStack{
            Color.primaryColor
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                Text("Congratulations!")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                
                
                Text("You got new answers from: ")
                    .foregroundColor(.white)
                    .font(.title)
                
                Spacer()
                
                newAnswersView()
                
                Spacer()
                
                Button(action: {
                    Task {
                        do {
                            try await qaViewModel.updateAnswers()
                            showingNewAnswersSheet.toggle()
                        } catch let error {
                            print("Error trying to deactive recent Answers: \(error)")
                        }
                    }
                }) {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(.red, lineWidth: 2)
                        .frame(width: 340, height: 60)
                        .overlay {
                            Text("Dismiss")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .bold()
                                .padding(5)
                        }
                }
                Spacer()
            }
        }
    }
    
    private func pickNewQuestionsSheet() -> some View {
        ZStack{
            Color.primaryColor
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                Text("Congratulations!")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                
                
                Text("You got new answers from: ")
                    .foregroundColor(.white)
                    .font(.title)
                
                Spacer()
                
                newAnswersView()
                
                Spacer()
                
                Button(action: {
                    Task {
                        do {
                            try await qaViewModel.updateAnswers()
                            showingNewAnswersSheet.toggle()
                        } catch let error {
                            print("Error trying to deactive recent Answers: \(error)")
                        }
                    }
                }) {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(.red, lineWidth: 2)
                        .frame(width: 340, height: 60)
                        .overlay {
                            Text("Dismiss")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .bold()
                                .padding(5)
                        }
                }
                Spacer()
            }
        }
    }
    
    private func newAnswersView() -> some View {
        ScrollView {
            ForEach(qaViewModel.recentQAs, id: \.self) { recentQA in
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(.white, lineWidth: 2)
                    .frame(width: 360, height: 80)
                    .overlay {
                        newAnswersBody(recentQA: recentQA)
                    }
                    .padding(5)
            }
        }
    }
    
    private func introSheet() -> some View {
        ZStack{
            Color.primaryColor
                .ignoresSafeArea()
            
            VStack{
                Text("Features:")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                
                
                Text("Q&A")
                    .foregroundColor(.white)
                    .font(.title)
                
                Text("BlindChat")
                    .foregroundColor(.white)
                    .font(.title)
                
            }
        }
    }
    
    private func newAnswersBody(recentQA: QAModel) -> some View {
        HStack {
            VStack{
                Circle()
                    .overlay(
                        Image(uiImage: recentQA.profileImage)
                            .resizable()
                            .foregroundColor(.black)
                    )
                    .frame(width: 50)
                    .foregroundColor(.gray)
                
                Text("John Doe")
                    .foregroundColor(.white)
                    .font(.system(size: 10))
                    .bold()
            }
            
            Spacer()
            
            VStack{
                Text("\(recentQA.question.body)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .bold()
                
                Text("\(recentQA.answer.body)")
                    .foregroundColor(.green)
                    .font(.system(size: 10))
            }
            Spacer()
            Button(action: {
                self.isHeartSelected.toggle()
            }) {
                Image(systemName: "heart.circle")
                    .resizable()
                    .foregroundColor(self.isHeartSelected ? .red : .white)
                    .frame(width: 25, height: 25)
            }
        }
        .padding()
    }
    
    private func launchVideoSession(pickedUser: ProfileModel) async throws {
        // this removes HMSPreBuiltView and triggers its onDisappear()
        // makes sure current video sesh has closed
        videoViewModel.roomCode = ""
        
        // Delay of 5 seconds (1 second = 1_000_000_000 nanoseconds)
        try? await Task.sleep(for: .seconds(5))
        
        videoViewModel.roomCode = pickedUser.roomCode
        //viewRouter.currentPage = .videoPage
    }
}

#Preview {
    HomeView(selectedTab: .constant(0))
        .environmentObject(ProfileViewModel())
        .environmentObject(VideoViewModel())
        .environmentObject(AppDelegate())
        .environmentObject(QAViewModel())
}
