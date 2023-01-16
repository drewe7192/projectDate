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
        ZStack{
            Color("Grey")
                .ignoresSafeArea()
            
            hostDisplay
        }
    }
    
     var hostDisplay: some View {
        ZStack{
            Text("")
                .font(.title.bold())
                .frame(width: 400, height: 100)
                .background(.white)
                .foregroundColor(.gray)
                .cornerRadius(20)
            
            HStack{
                Image("animeGirl")
                    .resizable()
                    .frame(width: 90, height: 90)
                    .background(.gray)
                    .clipShape(Circle())
                    .padding(.leading)
                
                VStack(alignment: .leading){
                    Text(sd.fullName)
                        .foregroundColor(.black)
                        .font(.system(size: 22))
                        .bold()
                    Text(convertTime(sd.time))
                    
                }
                
                Spacer()
                
                Text("\(sd.userRoleType)")
                    .font(.system(size: 20))
                    .padding(.trailing)
            }
            .padding(.trailing)
            
        }
     }
    
    
    func convertTime(_ foo: Int) -> (String){
        let now = Date.now
        let result = Calendar.current.date(byAdding: .second, value: -foo, to: now)
        let text = "\(String(describing: result))"
        
        let text2 = text.replacingOccurrences(of: "Optional(", with: "")
        
        let text3 = text2.replacingOccurrences(of: "+0000)", with: "")
        
        return text3;
    }
}

struct UpcomingCardView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingCardView(sd: MockService.userSampleData.sds.first!)
    }
}
