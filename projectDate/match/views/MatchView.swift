//
//  MatchView.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/9/23.
//

import SwiftUI
import AVFoundation
import Firebase

struct MatchView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var viewModel = LiveViewModel()
    
    @State private var userProfileImage: UIImage = UIImage()
    @State private var isNoMatches: Bool = false
    @State private var showHamburgerMenu: Bool = false
    @State private var activeImageIndex = 0
    @State private var activeImageIndex2 = 0
    @State private var activeImageIndex3 = 0
    @State private var startSpin: Bool = false
    @State private var question: String = ""
    @State private var showMatchPopover: Bool = false
    @State private var alertFor1v1SpeedMeet: Bool = false
    @State private var alertForGroupSpeedMeet: Bool = false
    @State private var tapped: Bool = false
    @State private var isSending: Bool = false
    @State private var isSent: Bool = false
    @State private var timeRemaining: Int = 86400
    @State private var raiseEmptyAlert: Bool = false
    @State private var imageIndex: Int = 0
   // @State private var showingInstructionsPopover: Bool = false
    @State private var showingBasicInfoPopover: Bool = false
    
    //let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let imageSwitchTimer = Timer.publish(every: 0.08, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        NavigationView{
            GeometryReader{ geoReader in
                ZStack{
                    ZStack{
                        Color.mainBlack
                            .ignoresSafeArea()
                        
                        VStack{
                            Text("Break the Ice: best answer wins")
                                .font(.system(size: geoReader.size.height * 0.05))
                                .bold()
                                .foregroundColor(.iceBreakrrrBlue)
                                .padding(.top,80)
                            
                            TextField("ask a question", text: $question)
                                .foregroundColor(.white)
                                .frame(width: 350, height: 25)
                                .padding()
                                .cornerRadius(20)
                                .textInputAutocapitalization(.never)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20).stroke(.white, lineWidth: 2)
                                )
                                .padding(.bottom,20)
                            
                            mainButtons(for: geoReader)
                                .padding(.bottom,30)
                            
                            potentialProfiles(for: geoReader)
                                .popover(isPresented: $showMatchPopover) {
                                    matchPopover(for: geoReader, imageIndex: self.imageIndex)
                                        //.interactiveDismissDisabled()
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
                    getAllData()
                    viewModel.getMatchStorageFiles(matchProfiles: MockService.profilesSampleData)
//                    viewModel.getUserProfile(){(profileId) -> Void in
//                        if profileId != "" {
//                            viewModel.getStorageFile(profileId: profileId)
//                            viewModel.getMatchStorageFiles(matchProfiles: MockService.profilesSampleData)
//                            //                                                viewModel.getMatchRecordsForPreviousWeek() {(matchRecordsPreviousWeek) -> Void in
//                            //                                                    if !matchRecordsPreviousWeek.isEmpty {
//                            //                                                        viewModel.getProfiles(matchRecords: matchRecordsPreviousWeek) {(matchProfiles) -> Void in
//                            //                                                            if !matchProfiles.isEmpty{
//                            //                                                                viewModel.getMatchStorageFiles(matchProfiles: matchProfiles)
//                            //                                                            }
//                            //                                                        }
//                            //                                                    } else {
//                            //                                                        self.isNoMatches.toggle()
//                            //                                                    }
//                            //                                                }
//                        }
//                    }
                }
//                .onReceive(timer) { time in
//                    if isSent{
//                        if timeRemaining > 0 {
//                            timeRemaining -= 1
//                        }
//                    }
//                }
                .alert(isPresented: $raiseEmptyAlert) {
                    Alert(title: Text("TextField is empty"), message: Text("please write out question"), dismissButton: .default(Text("Okay")))
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
    
    private func theBubble(for geoReader: GeometryProxy) -> some View {
        VStack{
            Text("prefer dogs")
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                .listRowSeparator(.hidden)
                .overlay(alignment: .bottomLeading) {
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.title)
                        .rotationEffect(.degrees(45))
                        .offset(x: -10, y: 10)
                        .foregroundColor(.blue)
                    
                }
        }
    }
    
    private func countdown(for geoReader: GeometryProxy) -> some View {
        HStack{
            Spacer()
            // .frame(width: 80)
            Text("2:58")
                .font(.system(size: 30))
                .foregroundColor(.white)
                .opacity(0.4)
            Spacer()
            // .frame(width: 50)
        }
    }
    
    private func mainButtons(for geoReader: GeometryProxy) -> some View{
        HStack{
            Button(action: {
                if !self.question.isEmpty {
                    isSending.toggle()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        isSent.toggle()
                        isSending.toggle()
                    }
                } else {
                    raiseEmptyAlert.toggle()
                }
             
            }) {
                Text("Send")
                    .bold()
                    .frame(width: 190, height: 50)
                    .background(Color.mainGrey)
                    .foregroundColor(.iceBreakrrrBlue)
                    .font(.system(size: 24))
                    .cornerRadius(15)
                    .shadow(radius: 8, x: 10, y:10)
                    .opacity(isSending || isSent ? 0.3 : 1)
            }
            .disabled(isSending || isSent ? true : false)
            
            Button(action: {
                AudioServicesPlaySystemSound(1103)
                startSpin.toggle()
                
                if !startSpin {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        //showMatchPopover.toggle()
                    }
                }
                
            }) {
                Text("refresh profiles")
                    .bold()
                    .frame(width: 190, height: 50)
                    .background(Color.mainGrey)
                    .foregroundColor(.iceBreakrrrBlue)
                    .font(.system(size: 24))
                    .cornerRadius(15)
                    .shadow(radius: 8, x: 10, y:10)
                    .opacity(isSending || isSent ? 0.3 : 1)
            }
            .disabled(isSending || isSent ? true : false)
        }
    }
    
    private func potentialProfiles(for geoReader: GeometryProxy) -> some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    showMatchPopover.toggle()
                    self.imageIndex = activeImageIndex
                }) {
                    ZStack{
                        if !viewModel.matchProfileImages.isEmpty {
                            Image(uiImage: viewModel.matchProfileImages[activeImageIndex])
                                .resizable()
                                .blur(radius: 15.0)
                                .cornerRadius(20)
                                .frame(width: 100, height: 100)
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
                        
                        Text("Tap to reveal")
                            .bold()
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .cornerRadius(20)
                            .opacity(0.4)
                    }
                }
              //  .disabled(isSending || isSent ? true : false)
                Spacer()
                profileAnswer(for: geoReader)
                Spacer()
            }
            
            HStack{
                Spacer()
                Button(action: {
                    showMatchPopover.toggle()
                    self.imageIndex = activeImageIndex2
                }) {
                    ZStack{
                        if !viewModel.matchProfileImages.isEmpty {
                            Image(uiImage: viewModel.matchProfileImages[activeImageIndex2])
                                .resizable()
                                .blur(radius: 15.0)
                                .cornerRadius(20)
                                .frame(width: 100, height: 100)
                                .background(.black.opacity(0.2))
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .onReceive(imageSwitchTimer) { _ in
                                    if startSpin {
                                        // Go to the next image. If this is the last image, go
                                        // back to the image #0
                                        self.activeImageIndex2 = (self.activeImageIndex2 + 3) % viewModel.matchProfileImages.count
                                    }
                                }
                        }
                        
                        Text("Tap to reveal")
                            .bold()
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .cornerRadius(20)
                            .opacity(0.4)
                    }
                }
              
                Spacer()
                profileAnswer(for: geoReader)
                Spacer()
            }
            
            HStack{
                Spacer()
                Button(action: {
                    showMatchPopover.toggle()
                    self.imageIndex = activeImageIndex3
                }) {
                    ZStack{
                        if !viewModel.matchProfileImages.isEmpty {
                            Image(uiImage: viewModel.matchProfileImages[activeImageIndex3])
                                .resizable()
                                .blur(radius: 15.0)
                                .cornerRadius(20)
                                .frame(width: 100, height: 100)
                                .background(.black.opacity(0.2))
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .onReceive(imageSwitchTimer) { _ in
                                    if startSpin {
                                        // Go to the next image. If this is the last image, go
                                        // back to the image #0
                                        self.activeImageIndex3 = (self.activeImageIndex3 + 2) % viewModel.matchProfileImages.count
                                    }
                                }
                        }
                        
                        Text("Tap to reveal")
                            .bold()
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .cornerRadius(20)
                            .opacity(0.4)
                    }
                }
               
                Spacer()
                profileAnswer(for: geoReader)
                Spacer()
            }
        }
    }
    
    private func matchPopover(for geoReader: GeometryProxy, imageIndex: Int) -> some View {
        VStack{
            Text("Connect with")
                .font(.system(size: geoReader.size.height * 0.05))
                .foregroundColor(.iceBreakrrrBlue)
                .padding()
            
            Text(MockService.profilesSampleData[imageIndex].fullName)
                .font(.system(size: geoReader.size.height * 0.05))
                .foregroundColor(.iceBreakrrrBlue)
                .padding()
            
            
            Image(uiImage: viewModel.matchProfileImages[imageIndex])
                .resizable()
                .cornerRadius(20)
                .frame(width: 250, height: 250)
                .background(.black.opacity(0.2))
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
            
            Button(action: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    alertFor1v1SpeedMeet.toggle()
                    tapped.toggle()
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
                
                tapped.toggle()
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
    }
    
    private func profileAnswer(for geoReader: GeometryProxy) -> some View{
        VStack{
            if isSending || isSent {
                if isSending {
                    HStack{
                        Text("sending...")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .opacity(0.3)
                        
                        ProgressView()
                }
                    
                } else if isSent {
                    HStack{
                        CountdownTimerView(timeRemaining: $timeRemaining, geoReader: geoReader, isStartNow: .constant(false), isTimeEnded: .constant(false), speedDates: [])
                    }
                    
                }
            } else {
               // theBubble(for: geoReader)
                Text("no question has been sent yet")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .opacity(0.3)
            }
        }
    }
    
    private func getAllData() {
        getProfileAndRecords() {(getProfileId) -> Void in
            if getProfileId != "" {
                viewModel.saveMessageToken()
            }
        }
    }
    
    private func getProfileAndRecords(completed: @escaping (_ getProfileId: String) -> Void) {
        if viewModel.userProfile.id == "" {
            viewModel.getUserProfile(){(profileId) -> Void in
                if profileId != "" {
                    //get profileImage
                    viewModel.getStorageFile(profileId: profileId)
                } else {
                    viewModel.createUserProfile() {(createdUserProfileId) -> Void in
                        if createdUserProfileId != "" {
                            let user = Auth.auth().currentUser?.email ?? ""
                            
                            // for apple sign in
                            if !user.contains("appleid") {
                                showingBasicInfoPopover.toggle()
                            }else {
                                viewModel.userProfile.gender = "male"
                            }
                        }
                        completed(createdUserProfileId)
                    }
                }
            }
        }
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView()
    }
}
