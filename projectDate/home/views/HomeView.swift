//
//  HomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/18/23.
//

import SwiftUI

import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage
import UIKit


struct HomeView: View {
    init(){
        
//        HomeViewModel().getAllData(foo: [""]){ (success) -> Void in
//            if success {
////                        self.readUserProfile()
////                        self.getStorageFile()
//            }
//        }
        
        
//        HomeViewModel().getCardsSwipedToday() { (success) -> Void in
//          //  if !success.isEmpty {
//                print("what is success and array", success)

//                HomeViewModel().getAllData(foo: [""]){ (success) -> Void in
//                    if success {
////                        self.readUserProfile()
////                        self.getStorageFile()
//                    }
//                }
                    //self.getCardFromIds(cardIds: success)
          //  }
       // }
    }
    
    @ObservedObject private var viewModel = HomeViewModel()
    @State private var showFriendDisplay = false
    @State private var progress: Double = 0.0
    @State private var valuesCount = 0.0
    @State private var littleThingsCount = 0.0
    @State private var commitmentCount = 0.0
    @State var showCardCreatedAlert: Bool = false
    @State private var image = UIImage()
    @State private var profileText = ""
    
    @State var cards: [CardModel] = []
    @State var lastDoc: Any = []
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView{
            GeometryReader{geoReader in
                ZStack{
                    Color.mainBlack
                        .ignoresSafeArea()
                    
                    VStack{
                        headerSection(for: geoReader)
                        Divider()
                            .frame(height: geoReader.size.height * 0.001)
                            .overlay(Color.iceBreakrrrPink)
                        
                        Text("\(displayText())")
                            .bold()
                            .foregroundColor(.white)
                            .font(.custom("Superclarendon", size: geoReader.size.height * 0.03))
                            .padding(.trailing,geoReader.size.width * 0.44)
                        
                        profilerSection(for: geoReader)
                        
                        
                        Text("How would your perfect match answer?")
                            .bold()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .font(.custom("Superclarendon", size: geoReader.size.height * 0.03))
                            .padding(geoReader.size.width * -0.03)
                        
                        cardsSection(for: geoReader)
                        
                    }
                }.position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY )
                    .alert(isPresented: $showCardCreatedAlert){
                        Alert(
                            title: Text("New Card Created!"),
                            message: Text("You'll get a notification if someone matches your perfered answer!")
                        )
                    }
            }
        }
    }
    
    private func headerSection(for geoReader: GeometryProxy) -> some View {
        ZStack{
            Image("logo")
                .resizable()
                .frame(width: 150,height: 50)
            
            NavigationLink(destination: SettingsView()) {
                Image(uiImage: viewModel.profileImage)
                    .resizable()
                    .cornerRadius(20)
                    .frame(width: 50, height: 50)
                    .background(Color.black.opacity(0.2))
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .padding(.leading, geoReader.size.width * 0.8)
            }
            
            // Dating/Friend Toggle button
            // adding this back in future versions

//            Toggle(isOn: $showFriendDisplay, label: {
//
//            })
//            .padding(geoReader.size.width * 0.02)
//            .toggleStyle(SwitchToggleStyle(tint: .white))
        }
    }
    
    private func profilerSection(for geoReader: GeometryProxy) -> some View {
        HStack {
            ZStack{
                CircularProgressView(progress: setProgress())
                    .frame(width: geoReader.size.width * 0.4, height: geoReader.size.height * 0.2)
                
                Text("\(progress * 100, specifier: "%.0f")%")
                    .font(.custom("Superclarendon", size: 45))
                    .foregroundColor(.white)
            }
            
            Spacer()
                .frame(width: geoReader.size.width * 0.1)
            
            VStack(alignment: .leading){
                VStack{
                    ProgressView("Values: " + "\(valuesCount)%", value: valuesCount, total: 100)
                        .foregroundColor(.white)
                        .tint(Color.iceBreakrrrPink)
                        .frame(width: geoReader.size.width * 0.4)
                        .onReceive(timer) {_ in
                            if valuesCount < (Double(viewModel.valuesCount.count) * 10)  {
                                valuesCount += 2
                            }
                        }
                }
                
                VStack{
                    ProgressView("little things: " + "\(littleThingsCount)%", value: littleThingsCount, total: 100)
                        .foregroundColor(.white)
                        .tint(.white)
                        .frame(width: geoReader.size.width * 0.4)
                        .onReceive(timer) {_ in
                            if littleThingsCount < (Double(viewModel.littleThingsCount.count) * 10) {
                                littleThingsCount += 2
                            }
                        }
                }
                
                VStack{
                    ProgressView("Commitment: " + "\(commitmentCount)%", value: commitmentCount, total: 100)
                        .foregroundColor(.white)
                        .tint(.white)
                        .frame(width: geoReader.size.width * 0.4)
                        .onReceive(timer) {_ in
                            if commitmentCount < (Double(viewModel.commitmentCount.count) * 10) {
                                commitmentCount += 2
                            }
                        }
                }
            }
        }
    }
    
    private func cardsSection(for geoReader: GeometryProxy) -> some View {
        ZStack{
            CardsView()
            VStack{
                NavigationLink(destination: CreateCardsView(showCardCreatedAlert: $showCardCreatedAlert)) {
                    ZStack{
                        Circle()
                            .foregroundColor(Color.iceBreakrrrPink)
                            .frame(width: geoReader.size.width * 0.2, height: geoReader.size.width * 0.2)
                            .shadow(radius: 10)
                        
                        Image(systemName:"plus")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                    }
                }
            }
            .position(x: geoReader.size.height * 0.07, y: geoReader.size.width * 0.85)
        }
    }
    
    private func displayText() -> String{
        showFriendDisplay ? (profileText = "Friend Profile") : (profileText = "Dating Profile")
        return profileText;
    }
    
    private func setProgress() -> Double{
        // might what to change this to update on only unique cards
        progress = Double(viewModel.cardsSwipedToday.count) * 0.1
        return Double(viewModel.cardsSwipedToday.count) * 5 * 0.01
    }
    
  
} 

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
