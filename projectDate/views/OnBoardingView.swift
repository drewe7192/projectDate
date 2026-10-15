//
//  OnBoardingView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 10/15/26.
//

import SwiftUI

struct OnBoardingView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var profileVM: ProfileViewModel
    @State private var isProcessing = false
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Visual Anchor
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 120, height: 120)
                Image(systemName: "video.badge.plus.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
            }
            
            Text("Enable Camera & Mic")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
            
            Text("Hotseat Live connects you through instant 20-second video interactions. You must allow access on the next two prompts so your camera feed and microphone tracks can initialize when your round goes live.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Spacer()
            
            // 🚨 PERSISTENT ACCIDENT WARNING: If they already tapped "Don't Allow" previously
            if profileVM.isPermissionDenied {
                VStack(spacing: 8) {
                    Text("⚠️ Access was previously denied.")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.red)
                    Text("Please open iPhone Settings -> Hotseat Live, toggle Camera & Microphone ON, then tap try again.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(.bottom, 10)
            }
            
            // ACTION BUTTON
            Button(action: {
                Task {
                    isProcessing = true
                    
                    // 🚀 KICK OFF SEQUENTIAL PROMPTS:
                    let accessApproved = await profileVM.requestCameraAndMicAccess()
                    
                    if accessApproved {
                        print("✅ Hardware clear! Routing player securely onto home dashboard framework.")
                        // Only let them break past the walkthrough once everything compiles clear!
                        viewRouter.currentPage = .homePage
                    }
                    
                    isProcessing = false
                }
            }) {
                HStack {
                    if isProcessing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text(profileVM.isPermissionDenied ? "Try Again / Open Settings" : "Grant Permissions & Enter")
                            .font(.headline)
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(profileVM.isPermissionDenied ? Color.red : Color.blue)
                .cornerRadius(14)
                .padding(.horizontal, 24)
            }
            .disabled(isProcessing)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    OnBoardingView()
}
