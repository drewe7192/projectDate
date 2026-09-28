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
            }
        }
        .task {
            do {
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
    }
}

#Preview {
    FullScreenComponentsView(isMicMuted: .constant(false), role: RoleType.host)
        .environmentObject(VideoViewModel())
        .environmentObject(AppDelegate())
        .environmentObject(ProfileViewModel())
}
