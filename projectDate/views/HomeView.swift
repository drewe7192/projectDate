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
            ZStack{
                // needed to keep color consistent
                Color.white
                    .ignoresSafeArea()
                
                VStack{
                    header
                    nextDateView
                        .padding(.top, 40)
                    exploreView
                        .padding(.top, 40)
                }
                .padding()
            }
        }
    }
    
    private var header: some View{
        HStack{
            //Gotta keep the naviagationLinks here in order to route in a menu
            NavigationLink(destination: SettingsView(), tag: 1, selection: $menuSelection) {}
            NavigationLink(destination: LikesView(), tag: 2, selection: $menuSelection) {}
            NavigationLink(destination: LikesView(), tag: 3, selection: $menuSelection) {}
            
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
                        .frame(width: 37, height: 7)
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    private var nextDateView: some View {
        VStack{
            Text("Next Date")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.largeTitle.bold())
                .foregroundColor(.black)
            
            NavigationLink(destination: sdHomeView(displayType: viewModel.user.sds.first!.userRoleType), label: {
                CountdownTimerView(timeRemaining: viewModel.user.sds.first!.time)
            })
        }
    }
    
    private var exploreView: some View {
        VStack{
            Text("Explore")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.largeTitle.bold())
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
