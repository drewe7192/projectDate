//
//  tabView.swift
//  projectDate
//
//  Created by DotZ3R0 on 11/21/22.
//

import SwiftUI

struct tabView: View {
    @StateObject  var viewModel = HomeViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20){
                ForEach(viewModel.people){ person in
                    HStack{
                        VStack(alignment: .leading, spacing: 5){
                            
                            NavigationLink(destination: ProfileView()) {
                                Image("animeGirl")
                                    .resizable()
                                
                            }
                            .frame(width: 150, height: 200)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                            
                            Text(person.fullName)
                                .bold()
                            
                            Text("West Palm Beach, FL")
                        }
                        
                        VStack( alignment: .leading, spacing: 5) {
                            NavigationLink(destination: ProfileView()) {
                                Image("animeGirl2")
                                    .resizable()
                            }
                            .frame(width: 150, height: 200)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                            
                            Text("Hane hane")
                                .bold()
                            
                            Text("Tampa, FL")
                        }
                    }
                    VStack{
                        NavigationLink(destination: ProfileView()) {
                            Image("animeGirl")
                                .resizable()
                        }
                        .frame(width: 300, height: 300)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        
                        Text("Hane hane")
                            .bold()
                        
                        Text("West Palm Beach, FL")
                    }
                }
            }
        }
    }
}

struct tabView_Previews: PreviewProvider {
    static var previews: some View {
        tabView(viewModel: HomeViewModel(forPreview: true))
    }
}
