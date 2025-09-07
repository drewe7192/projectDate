//
//  PickNewQuestionsSheet.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 9/7/25.
//

import SwiftUI

struct PickNewQuestionsSheet: View {
    let options: [String]
    @Binding var selectedOptions: Set<String>
    var onSubmit: () -> Void
    
    var body: some View {
        NavigationView {
                VStack {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(options, id: \.self) { option in
                                Button {
                                    toggle(option)
                                } label: {
                                    HStack {
                                        Text(option)
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                        Spacer()
                                        if selectedOptions.contains(option) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.blue)
                                                .transition(.scale)
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedOptions.contains(option) ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                    )
                                }
                                .buttonStyle(.plain)
                                .animation(.easeInOut, value: selectedOptions)
                            }
                        }
                        .padding()
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
                .navigationTitle("Select Options")
                .navigationBarTitleDisplayMode(.inline)
                .preferredColorScheme(.dark)
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
