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

struct SettingsView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var viewModel = HomeViewModel()
    
    @State var isLoggedOut = false
    @State private var image = UIImage()
    @State private var name = ""
    @State private var location = ""
    @State private var showSheet = false
    @State private var showSaveButton = false
    @State private var editInfo = false
    
    var body: some View {
        GeometryReader {geoReader in
            ZStack{
                Color.mainBlack
                    .ignoresSafeArea()
                
                VStack{
                    Text("Settings")
                        .foregroundColor(Color.white)
                        .bold()
                        .font(.system(size: geoReader.size.height * 0.05))
                }
                .position(x: geoReader.frame(in: .local).midX , y: geoReader.size.height * 0.03)
                
                VStack{
                    imageSection(for: geoReader)
                        .padding(geoReader.size.height * 0.03)
                    
                    infoSection(for: geoReader)
                        .padding(geoReader.size.height * 0.02)
                    
                    buttonsSection(for: geoReader)
                }
                .position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY)
                .sheet(isPresented: $showSheet){
                    // Pick an image from the photo library:
                    ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.profileImage)
                    
                    //  If you wish to take a photo from camera instead:
                    // ImagePicker(sourceType: .camera, selectedImage: self.$image)
                }
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
                Text("Upload Image")
                    .font(.headline)
                    .frame(width: geoReader.size.width * 0.6)
                    .frame(height: geoReader.size.height * 0.04)
                    .background(Color.mainGrey)
                    .cornerRadius(40)
                    .shadow(radius: 10, x: 10, y: 10)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .onTapGesture {
                        showSheet = true
                        showSaveButton = true
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
                            Text(name == "" ? "\(viewModel.userProfile.fullName)" : "\(name)")
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
                            Text(location == "" ? "\(viewModel.userProfile.location)" : "\(location)")
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
            //                        .fullScreenCover(isPresented: $isLoggedOut) {
            //                            SignInView()
            //                        }
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
            viewModel.updateUserProfile(updatedProfile: ProfileModel(id: viewModel.userProfile.id, fullName: name, location: location))
            
            viewModel.uploadStorageFile(image: viewModel.profileImage)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
