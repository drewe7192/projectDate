//
//  SettingsView.swift
//  DatingApp
//
//  Created by DotZ3R0 on 8/1/22.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseStorage

struct SettingsView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var viewModel = HomeViewModel()
    
    @State var isLoggedOut = false
    @State private var image = UIImage()
    @State private var name = ""
    @State private var location = ""
    @State private var showSheet = false
    @State private var showSaveButton = false
    @State private var editInfo = false
    @State private var showMenu: Bool = false
    @State private var userProfile: ProfileModel = ProfileModel(id: "", fullName: "", location: "", gender: "", matchDay: "", messageThreadIds: [], speedDateIds: [])
    
    let storage = Storage.storage()
    
    var body: some View {
        NavigationView {
            GeometryReader {geoReader in
                ZStack{
                    Color.mainBlack
                        .ignoresSafeArea()
                
                    VStack{
                            Text("Settings")
                                .foregroundColor(Color.white)
                                .bold()
                                .font(.system(size: geoReader.size.height * 0.05))
                        
                            imageSection(for: geoReader)
                                .padding(geoReader.size.height * 0.03)
                            
                            infoSection(for: geoReader)
                                .padding(geoReader.size.height * 0.02)
                            
                            buttonsSection(for: geoReader)
                    }
                    .sheet(isPresented: $showSheet){
                        // Pick an image from the photo library:
                        ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.profileImage)
                        
                        //  If you wish to take a photo from camera instead:
                        // ImagePicker(sourceType: .camera, selectedImage: self.$image)
                    }
                    .offset(x: self.showMenu ? geoReader.size.width/2 : 0)
                    .disabled(self.showMenu ? true : false)
                    
                    if self.showMenu {
                        MenuView()
                            .frame(width: geoReader.size.width/2)
                            .padding(.trailing,geoReader.size.width * 0.5)
                    }
                  
                }
                .position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY)
                .onAppear{
                    viewModel.getUserProfile(){(profileId) -> Void in
                        if profileId != "" {
                            viewModel.getStorageFile(profileId: profileId)
                        }
                    }
                }
                .navigationBarItems(leading: (
                        headerSection(for: geoReader)
                            .padding(.leading, geoReader.size.width * 0.25)
                ))
            }
        }
    }
    
    private func imageSection(for geoReader: GeometryProxy) -> some View {
        VStack{
            Image(uiImage: viewModel.profileImage)
                .resizable()
                .cornerRadius(50)
                .frame(width: 200, height: 200)
                .background(Color.black.opacity(0.2))
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
            
            if(editInfo){
                Button(action: {
                    showSheet = true
                }) {
                    Text("Upload Image")
                        .font(.headline)
                        .frame(width: geoReader.size.width * 0.6)
                        .frame(height: geoReader.size.height * 0.04)
                        .background(Color.mainGrey)
                        .cornerRadius(40)
                        .shadow(radius: 10, x: 10, y: 10)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                }
            }
        }
    }
    
    private func infoSection(for geoReader: GeometryProxy) -> some View {
        VStack{
            Text("Basic Info")
                .foregroundColor(Color.white)
                .font(.system(size: geoReader.size.height * 0.04))
                .padding(.trailing, geoReader.size.width * 0.55)
                .padding(.bottom, geoReader.size.height * 0.03)
            
            VStack{
                HStack{
                    VStack(alignment: .leading){
                        Text("Name")
                            .foregroundColor(Color.white)
                            .bold()
                            .font(.system(size: geoReader.size.height * 0.025))
                        
                        Spacer()
                            .frame(height: 20)
                        
                        Text("Location")
                            .foregroundColor(Color.white)
                            .bold()
                            .font(.system(size: geoReader.size.height * 0.025))
                    }
                
                    Spacer()
                        .frame(width: 200)
                    
                    VStack{
                        if(editInfo){
                            TextField("name", text: $name)
                                .frame(width: 100,height: 35)
                                .background(Color.mainGrey)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }else {
                            Text(name == "" ? "\(self.userProfile.fullName)" : "\(name)")
                                .foregroundColor(Color.white)
                                .font(.system(size: geoReader.size.height * 0.025))
                        }
                        
                        Spacer()
                            .frame(height: 20)
                        
                        if(editInfo){
                            TextField("location", text: $location)
                                .frame(width: 100,height: 35)
                                .background(Color.mainGrey)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }else {
                            Text(location == "" ? "\(self.userProfile.location)" : "\(location)")
                                .foregroundColor(Color.white)
                                .font(.system(size: geoReader.size.height * 0.025))
                        }
                    }
                }
            }
        }
    }
    
    private func buttonsSection(for geoReader: GeometryProxy) -> some View {
        VStack{
            Button(action: {
                editInfo.toggle()
                saveAllInfo()
            }) {
                Text(editInfo ? "Save Profile" : "Edit Profile")
                    .foregroundColor(.white)
                    .frame(width: geoReader.size.width * 0.7, height: geoReader.size.height * 0.06)
                    .background(Color.mainGrey)
                    .cornerRadius(geoReader.size.width * 0.04)
                    .shadow(radius: geoReader.size.width * 0.02, x: geoReader.size.width * 0.04, y: geoReader.size.width * 0.04)
            }
            
            Button(action: {
                signOutUser()
            }) {
                Text("Sign Out")
                    .foregroundColor(.white)
                    .frame(width: geoReader.size.width * 0.7, height: geoReader.size.height * 0.06)
                    .background(Color.mainGrey)
                    .cornerRadius(geoReader.size.width * 0.04)
                    .shadow(radius: geoReader.size.width * 0.02, x: geoReader.size.width * 0.04, y: geoReader.size.width * 0.04)
            }
        }
    }
    
    private func signOutUser(){
        let firebaseAuth = Auth.auth()
        do{
            //Google sign out.. dont think I need this
            //            GIDSignIn.sharedInstance.signOut()
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        viewRouter.currentPage = .signInPage
        isLoggedOut = true
    }
    
    private func saveAllInfo(){
        if(editInfo == false){
            uploadStorageFile(image: viewModel.profileImage, profileId: self.userProfile.id)
        }
    }
    
    public func uploadStorageFile(image: UIImage, profileId: String){
        let storageRef = storage.reference().child("\(String(describing: profileId))"+"/images/image.jpg")
        
        let data = image.jpegData(compressionQuality: 0.2)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        if let data = data {
            storageRef.putData(data, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error while uploading file: ", error)
                }
                
                if let metadata = metadata {
                    print("Metadata: ", metadata)
                }
            }
        }
    }
    
    private func headerSection(for geoReader: GeometryProxy) -> some View {
        ZStack{
            HStack{
                Text("iceBreakrrr")
                    .font(.custom("Georgia-BoldItalic", size: geoReader.size.height * 0.03))
                    .bold()
                    .foregroundColor(Color.iceBreakrrrBlue)
                    .position(x: geoReader.size.width * 0.3, y: geoReader.size.height * 0.03)
            
            Image("logo")
                .resizable()
                .frame(width: 40, height: 40)
                .background(Color.mainBlack)
                .position(x: geoReader.size.width * -0.35, y: geoReader.size.height * 0.03)
            }
            
            HStack{
                Button(action: {
                    withAnimation{
                        self.showMenu.toggle()
                    }
                }) {
                    ZStack{
                        Text("")
                            .frame(width: 40, height: 40)
                            .background(Color.black.opacity(0.2))
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
                .position(x: geoReader.size.height * -0.08, y: geoReader.size.height * 0.03)

                Spacer()
                    .frame(width: geoReader.size.width * 0.55)
                
                NavigationLink(destination: NotificationsView(), label: {
                    ZStack{
                        Text("")
                            .cornerRadius(20)
                            .frame(width: 40, height: 40)
                            .background(Color.black.opacity(0.2))
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
                    if(viewModel.profileImage != nil){
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
                                .background(.black.opacity(0.2))
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())

                            Image(systemName: "person.circle")
                                .resizable()
                                .cornerRadius(20)
                                .frame(width: 20, height: 20)
                                .background(Color.black.opacity(0.2))
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                        }
                    }
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
       
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
