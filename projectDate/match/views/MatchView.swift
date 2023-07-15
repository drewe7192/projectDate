//
//  MatchView.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/9/23.
//

import SwiftUI
import AVFoundation

struct MatchView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var viewModel = LiveViewModel()
    
    @State private var userProfileImage: UIImage = UIImage()
    @State private var isNoMatches: Bool = false
    @State private var showHamburgerMenu: Bool = false
    @State private var activeImageIndex = 0
    @State private var startSpin: Bool = false
    @State private var email: String = ""
    @State private var showMatchPopover: Bool = false
    @State private var alertFor1v1SpeedMeet: Bool = false
    @State private var alertForGroupSpeedMeet: Bool = false
    
    let imageSwitchTimer = Timer.publish(every: 0.08, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        GeometryReader{ geoReader in
            ZStack{
                ZStack{
                    Color.mainBlack
                        .ignoresSafeArea()
                    
                    VStack{
                        Text("Spin & Connect")
                            .font(.system(size: geoReader.size.height * 0.05))
                            .bold()
                            .foregroundColor(.white)
                        
                        if !viewModel.matchProfileImages.isEmpty {
                            Image(uiImage: viewModel.matchProfileImages[activeImageIndex])
                                .resizable()
                                .blur(radius: 15.0)
                                .cornerRadius(20)
                                .frame(width: 300, height: 300)
                                .background(.black.opacity(0.2))
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .onReceive(imageSwitchTimer) { _ in
                                    if startSpin {
                                        // Go to the next image. If this is the last image, go
                                        // back to the image #0
                                        self.activeImageIndex = (self.activeImageIndex + 1) % viewModel.matchProfileImages.count
                                    }
                                }
                        }
                        ZStack{
                            TextField("Category", text: $email)
                                .foregroundColor(.white)
                                .frame(width: 270, height: 25)
                                .padding()
                                .cornerRadius(10)
                                .textInputAutocapitalization(.never)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 2)
                                )
                                .padding(.bottom,3)
                        }
                        
                        Spacer()
                            .frame(height: 20)
                        
                        Button(action: {
                            AudioServicesPlaySystemSound(1103)
                            startSpin.toggle()
                            
                            if !startSpin {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    showMatchPopover.toggle()
                                }
                            }
                            
                        }) {
                            Text("Spin")
                                .bold()
                                .frame(width: 300, height: 70)
                                .background(Color.mainGrey)
                                .foregroundColor(.iceBreakrrrBlue)
                                .font(.system(size: 24))
                                .cornerRadius(20)
                                .shadow(radius: 8, x: 10, y:10)
                        }
                        .popover(isPresented: $showMatchPopover) {
                            VStack{
                                Text("Let's Connect")
                                    .font(.system(size: geoReader.size.height * 0.05))
                                    .foregroundColor(.iceBreakrrrBlue)
                                    .padding()
                                
                                
                                Image(uiImage: viewModel.matchProfileImages[activeImageIndex])
                                    .resizable()
                                    .cornerRadius(20)
                                    .frame(width: 250, height: 250)
                                    .background(.black.opacity(0.2))
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                
                                Button(action: {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        alertFor1v1SpeedMeet.toggle()
                                    }
                                }) {
                                    Text("1v1 SpeedMeet")
                                        .bold()
                                        .frame(width: 300, height: 70)
                                        .background(Color.mainGrey)
                                        .foregroundColor(.iceBreakrrrBlue)
                                        .font(.system(size: 24))
                                        .cornerRadius(20)
                                        .shadow(radius: 8, x: 10, y:10)
                                }
                                .alert(isPresented: $alertFor1v1SpeedMeet) {
                                    
                                    Alert(title: Text("Request sent!"), message: Text("a notification will popup if someone has accepted your request"), dismissButton: .default(Text("Got it!")) {
                                        showMatchPopover.toggle()
                                    })
                                }
                                
                                Button(action: {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        alertForGroupSpeedMeet.toggle()
                                    }
                                }) {
                                    Text("Group SpeedMeet")
                                        .bold()
                                        .frame(width: 300, height: 70)
                                        .background(Color.mainGrey)
                                        .foregroundColor(.iceBreakrrrBlue)
                                        .font(.system(size: 24))
                                        .cornerRadius(20)
                                        .shadow(radius: 8, x: 10, y:10)
                                }
                                .alert(isPresented: $alertForGroupSpeedMeet) {
                                    Alert(title: Text("Request sent!"), message: Text("a notification will popup if someone has accepted your request"), dismissButton: .default(Text("Got it!")) {
                                        showMatchPopover.toggle()
                                    })
                                }
                            }
                            .interactiveDismissDisabled()
                        }
                    }
                    headerSection(for: geoReader)
                        .padding(.leading, geoReader.size.width * 0.25)
                        .padding(.top,10)
                }
                
                //Display hamburgerMenu
                if self.showHamburgerMenu {
                    MenuView(showHamburgerMenu: self.$showHamburgerMenu)
                        .frame(width: geoReader.size.width/2)
                        .padding(.trailing,geoReader.size.width * 0.5)
                }
            }
            .ignoresSafeArea(edges: .top)
            .position(x: geoReader.frame(in: .local).midX, y: geoReader.frame(in: .local).midY)
            .onAppear{
                viewModel.getUserProfile(){(profileId) -> Void in
                    if profileId != "" {
                        viewModel.getStorageFile(profileId: profileId)
                        viewModel.getMatchStorageFiles(matchProfiles: MockService.profilesSampleData)
                        //                                                viewModel.getMatchRecordsForPreviousWeek() {(matchRecordsPreviousWeek) -> Void in
                        //                                                    if !matchRecordsPreviousWeek.isEmpty {
                        //                                                        viewModel.getProfiles(matchRecords: matchRecordsPreviousWeek) {(matchProfiles) -> Void in
                        //                                                            if !matchProfiles.isEmpty{
                        //                                                                viewModel.getMatchStorageFiles(matchProfiles: matchProfiles)
                        //                                                            }
                        //                                                        }
                        //                                                    } else {
                        //                                                        self.isNoMatches.toggle()
                        //                                                    }
                        //                                                }
                    }
                }
            }
        }
    }
    
    private func headerSection(for geoReader: GeometryProxy) -> some View {
        ZStack{
            HStack{
                HStack{
                    Image("logo")
                        .resizable()
                        .frame(width: 40, height: 40)
                    
                    Text("iceBreakrrr")
                        .font(.custom("Georgia-BoldItalic", size: geoReader.size.height * 0.03))
                        .bold()
                        .foregroundColor(Color.iceBreakrrrBlue)
                }
                
                HStack{
                    NavigationLink(destination: NotificationsView(), label: {
                        ZStack{
                            Text("")
                                .cornerRadius(20)
                                .frame(width: 40, height: 40)
                                .background(Color.black.opacity(0.6))
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                            
                            Image(systemName: "bell")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fill)
                        }
                    })
                    
                    NavigationLink(destination: SettingsView()) {
                        if(!viewModel.profileImage.size.width.isZero){
                            ZStack{
                                Text("")
                                    .cornerRadius(20)
                                    .frame(width: 40, height: 40)
                                    .background(.black.opacity(0.2))
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                
                                Image(uiImage: viewModel.profileImage)
                                    .resizable()
                                    .cornerRadius(20)
                                    .frame(width: 30, height: 30)
                                    .background(.black.opacity(0.2))
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                            }
                        } else {
                            ZStack{
                                Text("")
                                    .cornerRadius(20)
                                    .frame(width: 40, height: 40)
                                    .background(.black.opacity(0.6))
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .cornerRadius(20)
                                    .frame(width: 20, height: 20)
                                    .background(Color.black.opacity(0.6))
                                    .foregroundColor(.white)
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
            }
            .position(x: geoReader.size.width * 0.32, y: geoReader.size.height * 0.08)
            
            Button(action: {
                withAnimation{
                    self.showHamburgerMenu.toggle()
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
            .position(x: geoReader.size.width * -0.13, y: geoReader.size.height * 0.08)
        }
    }
    
    @Sendable private func delayOnAppear() async {
        // Delay of 3.5 seconds (1 second = 1_000_000_000 nanoseconds)
        try? await Task.sleep(nanoseconds: 6_500_000_000)
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView()
    }
}
