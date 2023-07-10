//
//  NotificationsView.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/21/23.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        ZStack{
            Color.mainBlack
                .ignoresSafeArea()
            
            VStack{
               Text("No Notifications at this time")
                    .foregroundColor(.mainGrey)
                    .opacity(0.5)
                    .font(.system(size: 50))
            }
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
