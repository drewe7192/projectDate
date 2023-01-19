//
//  EventView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/19/23.
//

import SwiftUI

struct EventInfoView: View {
    var body: some View {
        GeometryReader{ geoReader in
            VStack{
                HStack{
                    Image(systemName: "calendar.badge.clock")
                        .resizable()
                        .frame(width: geoReader.size.width * 0.15 ,height: geoReader.size.height * 0.06)
                    
                    VStack{
                        Text("Tuesday, Jan 22th")
                        Text("2:00pm")
                    }
                }
                
                Divider()
            }
       
        }
    }
}

struct EventInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EventInfoView()
    }
}
