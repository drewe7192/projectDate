//
//  HomeView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 2/18/25.
//

import SwiftUI
import Combine

struct HomeView: View {
    @State private var isSearching: Bool = false
   // @State private var names: [String] = ["Bob","John"]
    @State private var name: String = ""
    @State var timer: AnyCancellable?
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 40)
                    .fill(.gray)
                    .opacity(0.3)
                    .frame(width: 350, height: 80)
                
                if isSearching {
                    HStack{
                        Text("Searching for Friends")
                        ProgressView()
                    }
                } else {
                    VStack{
                        Text("\(self.name) wants to connect")
                            .id(self.name)
                            .transition(.opacity.animation(.smooth))
                            
                        HStack{
                            Button(action: {
                                
                            }) {
                                Text("Connect")
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                    .background(Color.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                            
                            Button(action: {
                                
                            }) {
                                Text("Cancel")
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                    .background(Color.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                        }
                    }
                }
            }
            
            RoomView()
            
            Text("Upcoming Events")
                .bold()
                .font(.system(size: 25))
            ScrollView(.horizontal) {
                
                HStack{
                    ForEach(1...3, id: \.self) {_ in
                        ZStack{
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.gray)
                                .opacity(0.3)
                                .frame(width: 200, height: 200)
                            VStack{
                                Text("Title")
                                Text("Event Date: Jan 3")
                                
                            }
                        }
                    }
                }
            }
          
        }
        .task {
            startRotation(with: ["Bob","John", "Mitchone"])
        }
    }
    
    
    private func startRotation(with names: [String]) {
        guard !names.isEmpty else { return }
        
        var index = 0
        self.name = names[0]
        self.timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect().sink { output in
            index = (index + 1) % names.count
            self.name = names[index]
        }
    }
}

#Preview {
    HomeView()
}

