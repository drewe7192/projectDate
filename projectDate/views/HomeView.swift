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
    @State private var titles: Array = ["Top-Rated", "Recommended",  "Upcoming"]
    
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
            Spacer()
            
            Menu {
                Button("Test1", action: function1)
                Button("Test2", action: function2)
                Button("Test3", action: function3)
            } label: {
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
            
            
            NavigationLink(destination: sdHomeView(),
                           label: {
                Text("Start Now! \n 0:00")
                    .multilineTextAlignment(.center)
                    .font(.title.bold())
                    .frame(width: 350, height: 80)
                    .background(.white)
                    .foregroundColor(.gray)
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 2))
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
                CustomSegmentedControl(selectedTab: $selectedTab, options: titles)
                
                switch(selectedTab) {
                case 0: TopRatedTabView()
                case 1: RecommendedTabView()
                case 2: UpcomingTabView()
                default: TopRatedTabView()
                }
            }
        }
    }
    
    func function1(){
        
    }
    
    func function2(){
        
    }
    
    func function3(){
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
