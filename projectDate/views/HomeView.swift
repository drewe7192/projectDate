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
            GeometryReader{geo in
                ZStack{
                    // needed to keep color consistent
                    Color("Grey")
                        .ignoresSafeArea()
                    
                    VStack{
                        header(for: geo)
                        nextDateView(for: geo)
                           .padding(.top, geo.size.height * 0.03)
                   
                        exploreView(for: geo)
                            .padding(.top, geo.size.height * 0.03)
                      
                    }
//                    .padding()
                }
                .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
            }
        }
    }
    
    private func header(for geo: GeometryProxy) -> some View {
        HStack{
            //Gotta keep the naviagationLinks here in order to route in a menu
            NavigationLink(destination: SettingsView(), tag: 1, selection: $menuSelection) {}
            NavigationLink(destination: LikesView(), tag: 2, selection: $menuSelection) {}
            NavigationLink(destination: LikesView(), tag: 3, selection: $menuSelection) {}
            Spacer()
            
            Text("Logo")
                .bold()
                .font(.system(size: geo.size.height * 0.04))
                .padding(.leading, geo.size.height * 0.05)
            
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
                        .frame(width: geo.size.width * 0.08, height: geo.size.height * 0.01)
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    private func nextDateView(for geo: GeometryProxy) -> some View {
        VStack{
            Text("Next Date")
                .frame(maxWidth: geo.size.width, alignment: .leading)
                .font(.title.bold())
                .foregroundColor(.black)
            
            NavigationLink(destination: sdHomeView(displayType: viewModel.user.sds.first!.userRoleType, sizing: geo), label: {
                CountdownTimerView(timeRemaining: viewModel.user.sds.first!.time, sizing: geo)
            })
        }
    }
    
    private func exploreView(for geo: GeometryProxy) -> some View {
        VStack{
            Text("Explore")
                .frame(maxWidth: geo.size.width, alignment: .leading)
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
