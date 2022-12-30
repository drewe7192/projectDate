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
        if sdTime.userRoleType == "host" {
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
                        Text("Invited by: John Blonde")
                            .font(.system(size: 15))
                        Text("August 4th, 2023")
                        Text("3:30pm")
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
                            Text("Emily Barron")
                        Text("August 4th, 2023")
                        Text("3:30pm")
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
