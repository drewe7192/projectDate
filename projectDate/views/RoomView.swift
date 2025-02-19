//
//  HomeView.swift
//  projectDate
//
//  Created by DotZ3R0 on 1/18/23.
//
import SwiftUI
import Firebase

struct RoomView: View {
        @StateObject var videoSDK = VideoSDK()
        @State var isJoining = false
        
        var body: some View {
            Group {
                if videoSDK.isJoined {
                        ForEach(videoSDK.tracks, id: \.self) { track in
                            VideoView(track: track)
                                .frame(height: 300)
                        }
                }
                else if isJoining {
                    ProgressView()
                }
                else {
                    ZStack{
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.red)
                            .frame(width: 350, height: 350)
                        
                        Text("Join")
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .onTapGesture {
                                videoSDK.joinRoom()
                                isJoining.toggle()
                            }
                    }
                 
                }
            }
        }
//    @StateObject public var viewModel = LiveViewModel()
//    @EnvironmentObject var viewRouter: ViewRouter
//    
//    @Binding var tabSelection: Int
//    @Binding var showAlert: Bool
//    
//    @State private var showingInstructionsPopover: Bool = false
//    @State private var showingBasicInfoPopover: Bool = false
//    @State private var showHamburgerMenu: Bool = false
//    @State private var circleColorChanged = false
//    @State private var heartColorChanged = false
//    @State private var heartSizeChanged = false
//    @State private var textOpacityChanged = false
//    @State private var launchJoinRoom = true
//    @State private var hasPeerJoined = true
//    @State private var emptyRooms: [RoomModel] = []
//    @State private var lookForRoom: Bool = false
//    @State private var isPeerWantsToJoin: Bool = true
//    @State private var category: String = ""
//    
//    
//    var body: some View {
//        NavigationView{
//            GeometryReader{ geoReader in
//                // this zStack is only being used for the hamburgerMenu
//                ZStack{
//                    ZStack{
//                        Color.mainBlack
//                            .ignoresSafeArea()
//                        
//                        ZStack{
//                            FacetimeView(liveViewModel: viewModel, launchJoinRoom: $launchJoinRoom, hasPeerJoined: $hasPeerJoined, lookForRoom: $lookForRoom)
//                            
////                            if !hasPeerJoined {
////                               if isPeerWantsToJoin {
////                                   incomingProfile(for: geoReader)
////                               } else {
////                                   loadingIcon(for: geoReader)
////                               }
////                            }
//        
//                        }
//                        .disabled(self.showHamburgerMenu ? true : false)
//                        
//                        headerSection(for: geoReader)
//                            .padding(.leading, geoReader.size.width * 0.25)
//                            .padding(.top,10)
//                        
//                                   
//                    }
//                    
//                    //Display hamburgerMenu
////                    if self.showHamburgerMenu {
////                        MenuView(showHamburgerMenu: self.$showHamburgerMenu)
////                            .frame(width: geoReader.size.width/2)
////                            .padding(.trailing,geoReader.size.width * 0.5)
////                    }
//                }
//                .ignoresSafeArea(edges: .top)
//                .position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY )
//                .onAppear {
//                   // getAllData()
////                    viewModel.getMatchStorageFiles()
//                  //  getAvailableRoom()
//                }
//                .popover(isPresented: $showingBasicInfoPopover) {
//                    BasicInfoPopoverView(userProfile: $viewModel.userProfile,profileImage: $viewModel.profileImage,showingBasicInfoPopover: $showingBasicInfoPopover, showingInstructionsPopover: $showingInstructionsPopover)
//                }
//                .alert(isPresented: $showAlert) {
//                    Alert(title: Text("Unable to connect"), message: Text("Cant find a friend at this time. Please try again or go to connect page"), primaryButton: .default(Text("Try again")), secondaryButton: .default(Text("connect page"), action: routeToConnectView))
//                }
//            }
//        }
//    }
//    
//    private func routeToConnectView(){
//        self.tabSelection = 3
//    }
//    
////    private func getAllData() {
////        getProfileAndRecords() {(getProfileId) -> Void in
////            if getProfileId != "" {
////                viewModel.saveMessageToken()
////            }
////        }
////    }
//    
//    private func getAvailableRoom(){
//        viewModel.getActiveSessions() {(activeSessions) -> Void in
//            if !activeSessions.data.isEmpty {
//                findRoom(activeSessions: activeSessions)
//            } else {
//                viewModel.getAllRooms() { (allRooms) -> Void in
//                    if !allRooms.data.isEmpty {
//                        let newRoom = allRooms.data.first(where: {$0.id != viewModel.currentSpeedDate.roomId})?.id
//                        viewModel.currentSpeedDate.roomId = newRoom ?? ""
//                        retrieveCodes()
//                    }
//                }
//            }
//        }
//    }
//    
////    private func getProfileAndRecords(completed: @escaping (_ getProfileId: String) -> Void) {
////        if viewModel.userProfile.id == "" {
////            viewModel.getUserProfile(){(profileId) -> Void in
////                if profileId != "" {
////                    //get profileImage
////                    viewModel.getStorageFile(profileId: profileId)
////                } else {
////                    viewModel.createUserProfile() {(createdUserProfileId) -> Void in
////                        if createdUserProfileId != "" {
////                            let user = Auth.auth().currentUser?.email ?? ""
////
////                            // for apple sign in
////                            if !user.contains("appleid") {
////                                showingBasicInfoPopover.toggle()
////                            }else {
////                                viewModel.userProfile.gender = "male"
////                            }
////                        }
////                        completed(createdUserProfileId)
////                    }
////                }
////            }
////        }
////    }
//    
//    private func headerSection(for geoReader: GeometryProxy) -> some View {
//        ZStack{
//            HStack{
//                HStack{
//                    Image("logo")
//                        .resizable()
//                        .frame(width: 40, height: 40)
//                    
//                    Text("iceBreakrrr")
//                        .font(.custom("Georgia-BoldItalic", size: geoReader.size.height * 0.03))
//                        .bold()
//                        .foregroundColor(Color.iceBreakrrrBlue)
//                }
//                
//                HStack{
//                    NavigationLink(destination: NotificationsView(), label: {
//                        ZStack{
//                            Text("")
//                                .cornerRadius(20)
//                                .frame(width: 40, height: 40)
//                                .background(Color.black.opacity(0.6))
//                                .aspectRatio(contentMode: .fill)
//                                .clipShape(Circle())
//                            
//                            Image(systemName: "bell")
//                                .resizable()
//                                .frame(width: 20, height: 20)
//                                .foregroundColor(.white)
//                                .aspectRatio(contentMode: .fill)
//                        }
//                    })
//                    
//                    NavigationLink(destination: SettingsView()) {
//                        if(!viewModel.profileImage.size.width.isZero){
//                            ZStack{
//                                Text("")
//                                    .cornerRadius(20)
//                                    .frame(width: 40, height: 40)
//                                    .background(.black.opacity(0.2))
//                                    .aspectRatio(contentMode: .fill)
//                                    .clipShape(Circle())
//                                
//                                Image(uiImage: viewModel.profileImage)
//                                    .resizable()
//                                    .cornerRadius(20)
//                                    .frame(width: 30, height: 30)
//                                    .background(.black.opacity(0.2))
//                                    .aspectRatio(contentMode: .fill)
//                                    .clipShape(Circle())
//                            }
//                        } else {
//                            ZStack{
//                                Text("")
//                                    .cornerRadius(20)
//                                    .frame(width: 40, height: 40)
//                                    .background(.black.opacity(0.6))
//                                    .aspectRatio(contentMode: .fill)
//                                    .clipShape(Circle())
//                                
//                                Image(systemName: "person.circle")
//                                Image(systemName: "person.circle")
//                                    .resizable()
//                                    .cornerRadius(20)
//                                    .frame(width: 20, height: 20)
//                                    .background(Color.black.opacity(0.6))
//                                    .foregroundColor(.white)
//                                    .aspectRatio(contentMode: .fill)
//                                    .clipShape(Circle())
//                            }
//                        }
//                    }
//                }
//            }
//            .position(x: geoReader.size.width * 0.32, y: geoReader.size.height * 0.08)
//            
//            Button(action: {
//                withAnimation{
//                    self.showHamburgerMenu.toggle()
//                }
//            }) {
//                ZStack{
//                    Text("")
//                        .frame(width: 35, height: 35)
//                        .background(Color.black.opacity(0.6))
//                        .aspectRatio(contentMode: .fill)
//                        .clipShape(Rectangle())
//                        .cornerRadius(10)
//                    
//                    Image(systemName: "line.3.horizontal.decrease")
//                        .resizable()
//                        .frame(width: 20, height: 10)
//                        .foregroundColor(.white)
//                        .aspectRatio(contentMode: .fill)
//                }
//            }
//            .position(x: geoReader.size.width * -0.13, y: geoReader.size.height * 0.08)
//        }
//    }
//    
//    private func loadingIcon(for geoReader: GeometryProxy) -> some View {
//        VStack{
//            VStack{
//                Text("Searching for meet...")
//                    .font(.system(size: 30))
//                    .foregroundColor(.white)
//                    .opacity(textOpacityChanged ? 1 : 0.1)
//                    .animation(Animation.linear(duration: 1).repeatForever())
//                
//            }
//            
//            ZStack {
//                Circle()
//                    .frame(width: geoReader.size.width * 0.15, height: geoReader.size.height * 0.15)
//                    .foregroundColor(circleColorChanged ? Color(.systemGray5) : .iceBreakrrrBlue)
//                    .animation(Animation.linear(duration: 1).repeatForever())
//                
//                Image(systemName: "globe.europe.africa.fill")
//                    .foregroundColor(heartColorChanged ? .iceBreakrrrBlue : .white)
//                    .font(.system(size: 45))
//                    .scaleEffect(heartSizeChanged ? 1.0 : 0.5)
//                    .animation(Animation.linear(duration: 1).repeatForever())
//            }
//            .onAppear {
//                self.circleColorChanged.toggle()
//                self.heartColorChanged.toggle()
//                self.heartSizeChanged.toggle()
//                self.textOpacityChanged.toggle()
//            }
//        }
//    }
//    
//    private func incomingProfile(for geoReader: GeometryProxy) -> some View {
//        VStack{
//            if !viewModel.matchProfileImages.isEmpty {
//                Image(uiImage: viewModel.matchProfileImages[0])
//                    .resizable()
//                    .cornerRadius(20)
//                    .frame(width: 200, height: 200)
//                    .background(.black.opacity(0.2))
//                    .aspectRatio(contentMode: .fill)
//                    .clipShape(Circle())
//            }
//            
//            Text("Wants to meet")
//                .font(.system(size: 30))
//                .foregroundColor(.white)
//            
//            HStack{
//                Button(action: {
////                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
////                                            alertFor1v1SpeedMeet.toggle()
////                                        }
//                }) {
//                    Text("Connect")
//                        .bold()
//                        .frame(width: 150, height: 70)
//                        .background(Color.mainGrey)
//                        .foregroundColor(.iceBreakrrrBlue)
//                        .font(.system(size: 24))
//                        .cornerRadius(20)
//                        .shadow(radius: 8, x: 10, y:10)
//                }
//                
//                Button(action: {
////                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
////                                            alertFor1v1SpeedMeet.toggle()
////                                        }
//                }) {
//                    Text("Nope")
//                        .bold()
//                        .frame(width: 150, height: 70)
//                        .background(Color.red)
//                        .foregroundColor(.iceBreakrrrBlue)
//                        .font(.system(size: 24))
//                        .cornerRadius(20)
//                        .shadow(radius: 8, x: 10, y:10)
//                }
//            }
//      
//            
//        }
//    }
//    
//    private func findRoom(activeSessions: GetActiveSessionsResponseModel ){
//        filterRooms(activeSessions: activeSessions.data) {(openRoom) -> Void in
//            if (openRoom != "") && (openRoom != "Gender is null") {
//                retrieveCodes()
//            } else if openRoom == "Gender is null"{
//                //Alert gender is null
//            } else {
//                /// need to filter out the active sessionss
//                viewModel.getAllRooms() { (allRooms) -> Void in
//                    if !allRooms.data.isEmpty {
//                        allRooms.data.forEach{ room in
//                            activeSessions.data.forEach{ actSesh in
//                                if room.id != actSesh.room_id {
//                                    emptyRooms.append(room)
//                                }
//                            }
//                        }
//                        if !emptyRooms.isEmpty {
//                            let newRoom = emptyRooms.first(where: {$0.id != viewModel.currentSpeedDate.roomId})?.id
//                            viewModel.currentSpeedDate.roomId = newRoom ?? ""
//                            
//                            retrieveCodes()
//                        }
//                    } else {
//                        viewModel.createRoom(){ (roomId) -> Void in
//                            if roomId != "" {
//                                retrieveCodes()
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    private func retrieveCodes(){
//        viewModel.getRoomCodes(){ (roomCodes) -> Void in
//            if !roomCodes.data.isEmpty {
//                roomCodes.data.forEach{ x in
//                    if x.role == "male"{
//                        viewModel.currentSpeedDate.maleRoomCode = x.code
//                    } else if x.role == "female" {
//                        viewModel.currentSpeedDate.femaleRoomCode = x.code
//                    }
//                }
//                launchJoinRoom = true
//            }
//            else {
//                viewModel.createRoomCodes() {(newRoomCodes) -> Void in
//                    if !newRoomCodes.data.isEmpty {
//                        newRoomCodes.data.forEach{ x in
//                            if x.role == "male"{
//                                viewModel.currentSpeedDate.maleRoomCode = x.code
//                            } else if x.role == "female" {
//                                viewModel.currentSpeedDate.femaleRoomCode = x.code
//                            }
//                        }
//                        launchJoinRoom = true
//                    }
//                }
//            }
//        }
//    }
//    
//    private func filterRooms(activeSessions: [ActiveSessionModel] ,completed: @escaping(_ openRoom: String) -> Void){
//        activeSessions.forEach{ x in
//            // making sure there's no more than 1 peer before joining room
//            if x.peers.count == 1 {
//                if viewModel.userProfile.gender != "" {
//                    // gender and role cant be the same
//                    if  x.peers.first!.value.role != viewModel.userProfile.gender.lowercased() {
//                        viewModel.currentSpeedDate.roomId = x.room_id
//                        completed(viewModel.currentSpeedDate.roomId)
//                    }
//                } else {
//                    completed("Gender is null")
//                }
//            }
//        }
//        completed("")
//    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
//        LiveView(tabSelection: .constant(1), showAlert: .constant(false))
        
        RoomView()
    }
}
