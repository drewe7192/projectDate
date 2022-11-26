//
//  HomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 8/3/22.
//

import SwiftUI


struct HomeView: View {
    
    @State var signOutProcessing = false
    @State private var selectedTab: Int = 0
    @State private var stuff: Array = ["Top", "New",  "Live"]
    
    var body: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
            
            VStack{
                HStack{
                    Image(systemName: "line.3.horizontal.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                    
                    Spacer()
                    
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
            
                
                
                Text("Next")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.largeTitle.bold())
                    .foregroundColor(.black)
                    .padding(.top,50)
                
                Text("Start Now! \n 0:00")
                    .multilineTextAlignment(.center)
                    .font(.title.bold())
                    .frame(width: 350, height: 80)
                    .background(.white)
                    .foregroundColor(.gray)
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 2))
                    .padding(.bottom,40)
                   
                
                Text("Daters")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title.bold())
                    .foregroundColor(Color.black)
                    
                  
                VStack{
                    CustomSegmentedControl(selectedTab: $selectedTab, options: stuff)
                    
                    switch(selectedTab) {
                    case 0: TopTabView()
                    case 1: NewTabView()
                    case 2: LiveTabView()
                    default: TopTabView()
                    }
                }
            }
            .padding()
       
        }
       
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
