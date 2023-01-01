//
//  UpcomingCardView.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/25/22.
//

import SwiftUI

struct UpcomingCardView: View {
    var sdTime: sdTimeModel
    
    var body: some View {
        if sdTime.userRoleType == "guest" {
            hostDisplay
        }
        else{
            guestDisplay
        }
    }
    
    private var hostDisplay: some View {
        ZStack{
           
                Text("")
                    .font(.title.bold())
                    .frame(width: 350, height: 80)
                    .background(.white)
                    .foregroundColor(.gray)
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(.black, lineWidth: 2))
                
                HStack{
                    VStack(alignment: .leading){
                        Text("Invited by" + ": " + sdTime.fullName)
                            .font(.system(size: 15))
                        Text(sdTime.time)
                    }
                }
            
     
        }
    }
    
    private var guestDisplay: some View {
        
        ZStack{
       
                Text("")
                    .font(.title.bold())
                    .frame(width: 350, height: 80)
                    .background(.white)
                    .foregroundColor(.gray)
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(.black, lineWidth: 2))
                
                HStack{
                        Image("animeGirl")
                            .resizable()
                        .frame(width: 60, height: 60)
                        .background(.gray)
                        .clipShape(Circle())
                        .padding(.trailing,30)
                    
                   
                    
                    VStack(alignment: .leading){
                        Text(sdTime.fullName)
                        Text(sdTime.time)
                    }
                }
            }
        
    }
}

struct UpcomingCardView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingCardView(sdTime: MockService.userSampleData.sdTimes.first!)
    }
}
