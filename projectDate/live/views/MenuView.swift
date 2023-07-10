//
//  MenuView.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/17/23.
//

import SwiftUI

struct MenuView: View {
    
    @Binding var showHamburgerMenu: Bool
    
    var body: some View {
        GeometryReader { geoReader in
            ZStack{
                VStack(alignment: .leading){
                    NavigationLink(destination: SettingsView()) {
                        HStack{
                            Image(systemName: "gear")
                                .foregroundColor(.gray)
                                .imageScale(.large)
                            Text("Settings")
                                .foregroundColor(.gray)
                                .font(.headline)
                        }
                        .padding(.top,100)
                    }
                 
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(red: 32/255, green: 32/255, blue: 32/255))
                
                
                
                
                Button(action: {
                    withAnimation{
                        showHamburgerMenu.toggle()
                    }
                }) {
                    ZStack{
                        Text("")
                            .frame(width: 35, height: 35)
                            .background(Color.black.opacity(0.6))
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Rectangle())
                            .cornerRadius(10)

                        Image(systemName: "line.3.horizontal.decrease")
                            .resizable()
                            .frame(width: 20, height: 10)
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fill)
                    }
                }
                .position(x: geoReader.size.width * 0.24, y: geoReader.size.height * 0.087)
            }
        }
     
      
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(showHamburgerMenu: .constant(true))
    }
}
