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
                            VStack(alignment: .leading, spacing: 5){
                                NavigationLink(destination: ProfileView()) {
                                    AsyncImage(url: URL(string: "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg")) { image in
                                        
                                        image.resizable()
                                    } placeholder: {
                                     
                                    }
                                }
                                .frame(width: 150, height: 200)
                                    .background(Color.black)
                                    .foregroundColor(.white)
                                    .cornerRadius(30)
                                    
                                Text("Hane hane")
                                    .bold()
                                
                                Text("West Palm Beach, FL")
                                    
                            }
                      
                            
                           
                            VStack( alignment: .leading, spacing: 5) {
                                NavigationLink(destination: ProfileView()) {
                                    AsyncImage(url: URL(string: "https://i.pinimg.com/originals/01/c6/f4/01c6f460f860a0c5d6a6c22d01716951.jpg")) { image in
                                        image.resizable()
                                    } placeholder: {
                                        
                                    }
                                }.frame(width: 150, height: 200)
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
                                AsyncImage(url: URL(string: "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg")) {image in
                                    image.resizable()
                                } placeholder: {
                                    
                                }
                            }.frame(width: 300, height: 300)
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
}

struct tabView_Previews: PreviewProvider {
    static var previews: some View {
        tabView()
    }
}
