//
//  NotificationsView.swift
//  ProjectDate
//
//  Created by DotZ3R0 on 6/6/25.
//

import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        ZStack{
            Color.primaryColor
                .ignoresSafeArea()
            VStack{
                HStack {
                    Button(action : {
                        viewRouter.currentPage = .homePage
                    }){
                        Image(systemName: "arrow.backward.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 30)
                            .foregroundColor(.secondaryColor)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .clipShape(Circle())
                    }
                    Spacer()
                }

                
                Spacer()
                
                Text("NO NOTIFICATIONS")
                    .foregroundColor(.white)
                    .font(.system(size: 30))
                
                Spacer()
            }
        
        }
    
    }
}

#Preview {
    NotificationsView()
}
