//
//  sdHomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 11/26/22.
//

import SwiftUI

struct sdHomeView: View {
    @StateObject var viewModel = sdViewModel()
    
    let displayType: String
    
    var body: some View {
        if(displayType == "host"){
            hostDisplay
        }
        else if(displayType == "guest") {
            guestDisplay
        }
    }
    
    private var info: some View {
        VStack{
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when Please be polite, please be kindd")
                .multilineTextAlignment(.center)
                .padding(.top,20)
            
            
            Text("Dont forget to")
                .multilineTextAlignment(.center)
                .padding(.top,20)
            
            Text("Have Fun!")
                .fontWeight(.bold)
                .font(.system(size: 40))
        }
    }
    
    private var hostDisplay: some View {
        
        VStack{
            ScrollView{
                ForEach(viewModel.sd.profiles){ participant in
                    NavigationLink(destination: ProfileView(participant: participant), label: {
                        sdCardView(participant: participant)
                    })
                  
                }
            }
            
            info
            
            //button
            NavigationLink(destination: FacetimeView(viewModel: .init(), sdvm: viewModel), label: {
                CountdownTimerView(timeRemaining: 1000)
            })
         
        }
    }
    
    private var guestDisplay: some View {
        VStack{
            ForEach(viewModel.sd.profiles){ profile in
                Text("fdsfsd")
            }
            
            info
            
            //button
            CountdownTimerView(timeRemaining: 800)
        }
    }
}

struct sdHomeView_Previews: PreviewProvider {
    static var previews: some View {
        sdHomeView(displayType: "host")
    }
}
