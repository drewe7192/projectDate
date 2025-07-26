//
//  MainView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 3/26/25.
//
import SwiftUI

struct MainView: View {
    @State var selectedTab = 0
     
     var body: some View {
         ZStack(alignment: .bottom){
             TabView(selection: $selectedTab) {
                 HomeView(selectedTab: self.$selectedTab)
                     .tag(0)
                 
//                 EventsView()
//                     .tag(1)

                 SettingsView()
                     .tag(2)

//                 MessagesView()
//                     .tag(3)
             }
             
             ZStack{
                 HStack{
                     ForEach((TabbedItems.allCases), id: \.self){ item in
                         Button{
                             selectedTab = item.rawValue
                         } label: {
                             CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                         }
                     }
                 }
                 .padding(6)
             }
             .frame(height: 55)
             .background(.gray.opacity(0.2))
             .cornerRadius(35)
             .padding(.horizontal, 26)
         }
     }
}

enum TabbedItems: Int, CaseIterable{
    case home = 0
    case events
    case settings
    case messages
    
    var title: String{
        switch self {
        case .home:
            return "Home"
        case .events:
            return "Events"
        case .settings:
            return "Settings"
        case .messages:
            return "Messages"
        }
    }
    
    var iconName: String{
        switch self {
        case .home:
            return "house"
        case .events:
            return "calendar"
        case .settings:
            return "gear"
        case .messages:
            return "message"
        }
    }
}

extension MainView{
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View{
        HStack(spacing: 10){
            Spacer()
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? .black : .gray)
                .frame(width: 25, height: 25)
            if isActive{
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(isActive ? .black : .gray)
            }
            Spacer()
        }
        // TODO: Use geometry.size.width instead of .infinity
        .frame(width: isActive ? .infinity : 55, height: 55)
        .background(isActive ? .gray.opacity(0.4) : .clear)
        .cornerRadius(30)
    }
}
