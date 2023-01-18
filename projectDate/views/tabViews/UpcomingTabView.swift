//
//  LiveTabView.swift
//  projectDate
//
//  Created by DotZ3R0 on 11/21/22.
//

import SwiftUI

struct UpcomingTabView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        GeometryReader{geoReader in
            ScrollView{
                VStack{
                    ForEach(viewModel.user.sds) { time in
                        UpcomingCardView(sd: time, geoReader: geoReader)
                    }
                }
            }
        }
     
    }
}

struct UpcomingTabView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingTabView()
    }
}
