//
//  tabView.swift
//  projectDate
//
//  Created by Drew Sutherland on 11/21/22.
//

import SwiftUI

struct tabView: View {
    var body: some View {
        NavigationView{
            ScrollView {
                
                VStack(spacing: 20){
                    ForEach(0..<10){_ in
                        HStack{
                            NavigationLink(destination: ProfileView()) {
                                Text("dater profile")
                            }.frame(width: 150, height: 200)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(30)
                            
                            NavigationLink(destination: ProfileView()){
                                Text("dater profile")
                            }.frame(width: 150, height: 200)
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(30)
                            
                        }
                        HStack{
                            NavigationLink(destination: ProfileView()) {
                                Text("dater profile")
                            }.frame(width: 300, height: 300)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(30)
                        }
                    }
                }
            }
        }
    }
}

struct tabView_Previews: PreviewProvider {
    static var previews: some View {
        tabView()
    }
}
