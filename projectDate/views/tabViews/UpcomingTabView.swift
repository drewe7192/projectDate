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
                    ForEach(viewModel.user.userProfile.sds, id:\.?.id) { time in
                        UpcomingCardView(sd: time ?? MockService.sdSampleData, geoReader: geoReader)
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
