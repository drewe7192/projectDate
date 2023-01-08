//
//  UpcomingCardView.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/25/22.
//

import SwiftUI

struct UpcomingCardView: View {
    var sd: sdModel
    
    var body: some View {
        if sd.userRoleType == "guest" {
            NavigationLink(destination: sdInfoView(), label: {
                hostDisplay
            })
            
        }
        else{
            NavigationLink(destination: sdInfoView(), label: {
                guestDisplay
            })
            
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
                        Text("Invited by" + ": " + sd.fullName)
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                        Text("\(sd.time)")
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
                        Text(sd.fullName)
                        Text("\(sd.time)")
                    }
                }
            }
        
    }
}

struct UpcomingCardView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingCardView(sd: MockService.userSampleData.sds.first!)
    }
}
