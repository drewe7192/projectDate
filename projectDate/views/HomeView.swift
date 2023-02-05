//
//  HomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 8/3/22.
//

import SwiftUI


struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    @State var signOutProcessing = false
    @State private var selectedTab: Int = 0
    @State var menuSelection: Int? = 0
    
    var body: some View {
        NavigationView{
            GeometryReader{geoReader in
                ZStack{
                    // needed to keep color consistent
                    Color("Grey")
                        .ignoresSafeArea()
                    
                    VStack{
                        header(for: geoReader)
                        nextDateView(for: geoReader)
                            .padding(.top, geoReader.size.height * 0.03)
                        
                        exploreView(for: geoReader)
                            .padding(.top, geoReader.size.height * 0.03)
                        
                    }
                }
                .position(x: geoReader.frame(in: .local).midX, y: geoReader.frame(in: .local).midY)
            }
        }
    }
    
    private func header(for geoReader: GeometryProxy) -> some View {
        HStack{
            //Gotta keep the naviagationLinks here in order to route in a menu
            NavigationLink(destination: SettingsView(), tag: 1, selection: $menuSelection) {}
            NavigationLink(destination: LikesView(), tag: 2, selection: $menuSelection) {}
            NavigationLink(destination: LikesView(), tag: 3, selection: $menuSelection) {}
            Spacer()
            
            Text("Logo")
                .bold()
                .font(.system(size: geoReader.size.height * 0.04))
                .padding(.leading, geoReader.size.height * 0.05)
            
            Spacer()
            
            Menu {
                Button("Settings") {
                    self.menuSelection = 1
                }
                Button("Test1") {
                    self.menuSelection = 2
                }
                Button("Test2") {
                    self.menuSelection = 3
                }
            } label: {
                //this is the 3 dots
                Label {
                    Text("")
                } icon: {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .frame(width: geoReader.size.width * 0.08, height: geoReader.size.height * 0.01)
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    private func nextDateView(for geoReader: GeometryProxy) -> some View {
        VStack{
            Text("Next Date")
                .frame(maxWidth: geoReader.size.width, alignment: .leading)
                .font(.title.bold())
                .foregroundColor(.black)
            
            NavigationLink(destination: sdHomeView(displayType: viewModel.user.userProfile.sds.first??.userRoleType ?? "host"),
                           label: {
//                                CountdownTimerView(timeRemaining: viewModel.user.userProfile.sds.first!?.time ?? 3838374, geoReader: geoReader)
            })
        }
    }
    
    private func exploreView(for geoReader: GeometryProxy) -> some View {
        VStack{
            Text("Explore")
                .frame(maxWidth: geoReader.size.width, alignment: .leading)
                .font(.title.bold())
                .foregroundColor(.black)
            
            VStack{
                CustomSegmentedControl(selectedTab: $selectedTab, options: viewModel.tabTitles)
                
                switch(selectedTab) {
                case 0: TopRatedTabView()
                case 1: RecommendedTabView()
                case 2: UpcomingTabView()
                default: TopRatedTabView()
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
