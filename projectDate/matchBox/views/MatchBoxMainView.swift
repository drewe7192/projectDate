//
//  MatchBoxMainView.swift
//  projectDate
//
//  Created by dotZ3R0 on 11/11/22.
//

import SwiftUI

struct MatchBoxMainView: View {
    var body: some View {
        NavigationView{
            ZStack{
                CustomHeaderView()
                
                VStack(spacing: 10){
                    VStack{
                        Text("Top Date")
                            .bold()
                            .font(.title2)
                    }
                    .padding(.top,400)
                    VStack{
                        
                        HStack(spacing: 20){

                            AsyncImage(url: URL(string:
                                                    "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg"))
                            .frame(width: 100, height: 100)
                            .background(.gray)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(.blue, lineWidth: 10))
                            .offset(y: -100)
                            .padding(.top,30)
                            .padding(.bottom, 20)

                            AsyncImage(url: URL(string:
                                                    "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg"))
                            .frame(width: 100, height: 100)
                            .background(.gray)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(.blue, lineWidth: 10))
                            .offset(y: -100)
                            .padding(.top,30)
                            .padding(.bottom, 20)

                            AsyncImage(url: URL(string:
                                                    "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg"))
                            .frame(width: 100, height: 100)
                            .background(.gray)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(.blue, lineWidth: 10))
                            .offset(y: -100)
                            .padding(.top,30)
                            .padding(.bottom, 20)


                            AsyncImage(url: URL(string:
                                                    "https://i.pinimg.com/236x/af/1c/30/af1c30d6d881d9447dec06149f61d2f9--drawings-of-girls-anime-drawings-girl.jpg"))
                            .frame(width: 100, height: 100)
                            .background(.gray)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(.blue, lineWidth: 10))
                            .offset(y: -100)
                            .padding(.top,30)
                            .padding(.bottom, 20)
                       }
                    }
               
                   
              
                    
                    VStack{
                        Text("Previous Dates")
                            .bold()
                            .font(.title2)
                        
                            ScrollView{
                                VStack(spacing: 20){
                                    ForEach(0..<10){
                                        Text("DaterProfile \($0)")
                                            .foregroundColor(.white)
                                            .font(.largeTitle)
                                            .frame(width: 300, height: 80)
                                            .background(.red)
                                            .cornerRadius(30)
                                    }
                                }
                            }
                        
                    }
          
                        

                    Text("Live Dates")
                    Text("Date Starts in:")
                }
                
            }
            
        }
     
   
    }
}

struct MatchBoxMainView_Previews: PreviewProvider {
    static var previews: some View {
        MatchBoxMainView()
    }
}
