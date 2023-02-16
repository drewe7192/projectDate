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
    @State private var progress: Double = 0.0
    @State private var valueCount = 0.0
    @State private var qualityCount = 0.0
    @State private var commitCount = 0.0
    
    @State private var profileText = ""
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
                        
                        Text("\(displayText())")
                            .bold()
                            .foregroundColor(.white)
                            .font(.custom("Superclarendon", size: geoReader.size.height * 0.03))
                            .padding(.trailing,geoReader.size.width * 0.44)
                        
                        profilerSection(for: geoReader)
                        cardsSection(for: geoReader)
                        
                    }
                }.position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY )
            }
        }
    }
    
    private func headerSection(for geoReader: GeometryProxy) -> some View {
        ZStack{
            Image("logoBlue")
                .resizable()
                .frame(width: 105,height: 35)
            
            Toggle(isOn: $showFriendDisplay, label: {
                
            })
            .padding(geoReader.size.width * 0.02)
            .toggleStyle(SwitchToggleStyle(tint: .white))
        }
    }
    
    private func profilerSection(for geoReader: GeometryProxy) -> some View {
        HStack {
            ZStack{
                // 20 cards is equal to 100%: 20 * 5 = 100
                // the 0.01 is just something thats needed to make the Double type work properly
                
                CircularProgressView(progress: setProgress())
                    .frame(width: geoReader.size.width * 0.4, height: geoReader.size.height * 0.2)
                
                
                Text("\(progress * 100, specifier: "%.0f")%")
                    .font(.custom("Superclarendon", size: 45))
                    .foregroundColor(.white)
            }
            
            Spacer()
                .frame(width: geoReader.size.width * 0.1)
            
            VStack(alignment: .leading){
                VStack{
                    ProgressView("Values:" + "\(valueCount)%", value: valueCount, total: 100)
                        .foregroundColor(.white)
                        .tint(.white)
                        .frame(width: geoReader.size.width * 0.4)
                        .onReceive(timer) {_ in
                            if valueCount < 100 {
                                valueCount += 2
                            }
                        }
                }
                
                VStack{
                    ProgressView("Qualities:" + "\(qualityCount)%", value: qualityCount, total: 100)
                        .foregroundColor(.white)
                        .tint(.white)
                        .frame(width: geoReader.size.width * 0.4)
                        .onReceive(timer) {_ in
                            if qualityCount < (Double(viewModel.qualitiesCount.count) * 10) {
                                qualityCount += 2
                            }
                        }
                }
                
                VStack{
                    ProgressView("Commit:" + "\(commitCount)%", value: commitCount, total: 100)
                        .foregroundColor(.white)
                        .tint(.white)
                        .frame(width: geoReader.size.width * 0.4)
                        .onReceive(timer) {_ in
                            if commitCount < 100 {
                                commitCount += 2
                            }
                        }
                }
            }
        }
    }
    
    private func cardsSection(for geoReader: GeometryProxy) -> some View {
        ZStack{
            CardsView()
            VStack{
                NavigationLink(destination: CreateCardsView()) {
                    ZStack{
                        Circle()
                            .frame(width: geoReader.size.width * 0.2, height: geoReader.size.width * 0.2)
                            .shadow(radius: 10)
                        
                        Image(systemName:"plus")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                    }
                }
            }
            .position(x: geoReader.size.height * 0.07, y: geoReader.size.width * 0.85)
        }
    }
    
    private func displayText() -> String{
        showFriendDisplay ? (profileText = "Friend Profile"): (profileText = "Dating Profile")
        return profileText;
    }
    
    private func setProgress() -> Double{
        progress = Double(viewModel.cardsSwipedToday.count) * 0.1
        return Double(viewModel.cardsSwipedToday.count) * 5 * 0.01
    }
} 

struct LocalHomeView_Previews: PreviewProvider {
    static var previews: some View {
        LocalHomeView()
    }
}
