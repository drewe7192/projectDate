//
//  MessageCardView.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/31/23.
//

import SwiftUI

struct MessageCardView: View {
    var body: some View {
        GeometryReader {geoReader in
            ZStack{
                Text("")
                    .frame(width: 400, height: 90)
                    .font(.title.bold())
                    .background(Color.mainGrey)
                    .foregroundColor(.gray)
                    .cornerRadius(geoReader.size.width * 0.5)

                HStack{
                    Image("animeGirl")
                        .resizable()
                        .frame(width: geoReader.size.width * 0.15, height: geoReader.size.width * 0.15)
                    .background(.gray)
                    .clipShape(Circle())
                    .padding()

                    VStack(alignment: .leading){
                        Text("Bob Barron")
                            .foregroundColor(.white)
                        Text("Yo that b was tripping bro")
                            .foregroundColor(.gray)
                    }
                }
            }

        }
    }
}

struct MessageCardView_Previews: PreviewProvider {
    static var previews: some View {
        MessageCardView()
    }
}
