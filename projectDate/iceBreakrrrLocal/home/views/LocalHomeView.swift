//
//  HomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/18/23.
//

import SwiftUI

struct LocalHomeView: View {
    @ObservedObject private var viewModel = LocalHomeViewModel()
    @State private var showFriendDisplay = true
    @State private var progress: Double = 0.4
    @State private var downloadAmount = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView{
            GeometryReader{geoReader in
                ZStack{
                    Color(.systemTeal)
                        .ignoresSafeArea()
                    
                    VStack{
                        headerSection(for: geoReader)
                        Divider()
                        
                        Text(showFriendDisplay ? "Friend Profile": "Dating Profile")
                            .bold()
                            .foregroundColor(.white)
                            .font(.custom("Superclarendon", size: 25))
                            .padding(.trailing,170)
                            .padding(.leading,5)
                        
                        profilerSection(for: geoReader)
                        cardsSection(for: geoReader)
                        
                    }
                }.position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY )
            }
        }
    }
    
    private func headerSection(for geoReader: GeometryProxy) -> some View {
        ZStack{
            Text("Logo")
                .bold()
                .font(.system(size: 30))
            
            Toggle(isOn: $showFriendDisplay, label: {
                
            })
            .padding()
            .toggleStyle(SwitchToggleStyle(tint: .white))
            
        }
    }
    
    private func profilerSection(for geoReader: GeometryProxy) -> some View {
        HStack {
            ZStack{
                CircularProgressView(progress: progress)
                    .frame(width: 130, height: 130)
                
                
                Text("\(progress * 100, specifier: "%.0f")%")
                    .font(.custom("Superclarendon", size: 45))
                    .foregroundColor(.white)
            }
            
            Spacer()
                .frame(width: 40)
            
            VStack{
                VStack(alignment: .leading){
                    VStack{
                        ProgressView("Values:" + "\(downloadAmount)%", value: downloadAmount, total: 100)
                            .foregroundColor(.white)
                            .tint(.white)
                            .frame(width: 150)
                            .onReceive(timer) {_ in
                                if downloadAmount < 100 {
                                    downloadAmount += 2
                                }
                            }
                    }
                    
                    VStack{
                        ProgressView("Qualities:" + "\(downloadAmount)%", value: downloadAmount, total: 100)
                            .foregroundColor(.white)
                            .tint(.white)
                            .frame(width: 150)
                            .onReceive(timer) {_ in
                                if downloadAmount < 100 {
                                    downloadAmount += 2
                                }
                            }
                    }
                    
                    VStack{
                        ProgressView("Commit:" + "\(downloadAmount)%", value: downloadAmount, total: 100)
                            .foregroundColor(.white)
                            .tint(.white)
                            .frame(width: 150)
                            .onReceive(timer) {_ in
                                if downloadAmount < 100 {
                                    downloadAmount += 2
                                }
                            }
                    }
                }
            }
        }
    }
    
    private func cardsSection(for geoReader: GeometryProxy) -> some View {
        VStack{
            SwipeCardsView()
        }
    }
}

struct LocalHomeView_Previews: PreviewProvider {
    static var previews: some View {
        LocalHomeView()
    }
}

extension Color {
    static let realColor = Color("iceBreakrrrBlue")
}
