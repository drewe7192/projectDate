//
//  PickNewQuestionsSheet.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 9/7/25.
//

import SwiftUI

struct PickNewQuestionsSheet: View {
    @EnvironmentObject var qaViewModel: QAViewModel
    
    let options: [QuestionModel]
    @Binding var selectedOptions: Set<String>
    var onSubmit: () -> Void
    
    var body: some View {
        NavigationView {
                VStack {
                    ScrollView {
                        randomQuestions()
                    }
                    
                    Button(action: onSubmit) {
                        Text("Submit")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(14)
                            .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
                .task {
                    do {
                        try await qaViewModel.getQuestions(isNewUser: true)
                    } catch {
                        // handle error
                    }
                }
                .navigationTitle("Select Little Things")
                .navigationBarTitleDisplayMode(.inline)
                .preferredColorScheme(.dark)
        }
    }
    
    func randomQuestions() -> some View {
        LazyVStack(spacing: 12) {
            ForEach(options, id: \.self) { option in
                Button {
                    toggle(option.id)
                } label: {
                    HStack {
                        Text(option.body)
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                        if selectedOptions.contains(option.id) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                                .transition(.scale)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedOptions.contains(option.id) ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                    )
                }
                .buttonStyle(.plain)
                .animation(.easeInOut, value: selectedOptions)
            }
        }
    }
    
    private func toggle(_ option: String) {
        if selectedOptions.contains(option) {
            selectedOptions.remove(option)
        } else {
            selectedOptions.insert(option)
        }
    }
}




