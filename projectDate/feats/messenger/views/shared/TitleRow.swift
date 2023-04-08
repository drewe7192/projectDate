//
//  TitleRow.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/31/23.
//

import SwiftUI

struct TitleRow: View {
    var imageUrl = URL(string: "https://upload.wikimedia.org/wikipedia/commons/f/f5/Poster-sized_portrait_of_Barack_Obama.jpg")
    var name = "Pres Obama"
    
    var body: some View {
        HStack(spacing: 20) {
            AsyncImage(url: imageUrl) {image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading){
                Text(name)
                    .font(.title).bold()
                    .foregroundColor(.white)
                
                Text("Online")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            Image(systemName: "phone.fill")
                .foregroundColor(.white)
                .padding(10)
                .background(Color.iceBreakrrrBlue)
                .cornerRadius(50)
        }.background(Color.mainBlack)
    }
}

struct TitleRow_Previews: PreviewProvider {
    static var previews: some View {
        TitleRow()
            .background(.blue)
    }
}

