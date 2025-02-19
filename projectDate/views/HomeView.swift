//
//  HomeView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 2/18/25.
//

import SwiftUI

struct HomeView: View {
    @State private var isSearching: Bool = false
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 25)
                    .fill(.gray)
                    .frame(width: 350, height: 100)
                
                if isSearching {
                    HStack{
                        Text("Searching for Friends")
                        ProgressView()
                    }
                } else {
                    VStack{
                        Text("John wants to connect")
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
                .font(.system(size: 30))
            HStack{
                ForEach(1...3, id: \.self) {_ in
                    ZStack{
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.gray)
                            .frame(width: 150, height: 160)
                        VStack{
                            Text("Title")
                            Text("Event Date: Jan 3")
                            
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

