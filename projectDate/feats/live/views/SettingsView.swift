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
    @StateObject var viewModel = LiveViewModel()
    
    @State public var isLoggedOut = false
    @State private var image = UIImage()
    @State private var name = ""
    @State private var location = ""
    @State private var showSheet = false
    @State private var showSaveButton = false
    @State private var editInfo = false
//    @State private var userProfile: ProfileModel = ProfileModel(id: "", fullName: "", location: "", gender: "", matchDay: "", messageThreadIds: [], speedDateIds: [])
    @State private var genderChoices: [String] = ["Female","Male"]
    @State private var matchDayChoices: [String] = ["Saturday","Friday","Thursday","Wednesday","Tuesday","Monday","Sunday"]
    @State private var isDeletingAccount: Bool = false
    @State private var showHamburgerMenu: Bool = false
    
    let storage = Storage.storage()
    
    var body: some View {
        NavigationView {
            GeometryReader {geoReader in
                ZStack{
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
                                
                            Spacer()
                                .frame(height: geoReader.size.width * 0.07)
                            
                            nameSection(for: geoReader)
                            
                            Spacer()
                                .frame(height: geoReader.size.height * 0.02)
                            
                            pickerSections(for: geoReader)
                                
                                buttonsSection(for: geoReader)
                        }
                        .sheet(isPresented: $showSheet){
                            // Pick an image from the photo library:
                            ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.profileImage)
                            
                            //  If you wish to take a photo from camera instead:
                            // ImagePicker(sourceType: .camera, selectedImage: self.$image)
                        }
                        
                        headerSection(for: geoReader)
                            .padding(.leading, geoReader.size.width * 0.25)
                            .padding(.top,10)
                    }
                    
                    if self.showHamburgerMenu {
                        MenuView(showHamburgerMenu: self.$showHamburgerMenu)
                            .frame(width: geoReader.size.width/2)
                            .padding(.trailing,geoReader.size.width * 0.5)
                    }
                }
                .ignoresSafeArea(edges: .top)
                .position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY)
                .onAppear{
                    viewModel.getUserProfile(){(profileId) -> Void in
                        if profileId != "" {
                            viewModel.getStorageFile(profileId: profileId)
                        }
                    }
                }
                .alert(isPresented: $isDeletingAccount){
                    Alert(
                        title: Text("Error deleting account"),
                        message: Text("This operation is sensitive and requires recent authentication. Log in again before retrying this request")
                    )
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
            
            Button(action: {
                deleteUser()
            }) {
                Text("DELETE ACCOUNT")
                    .foregroundColor(.red)
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
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        viewRouter.currentPage = .signInPage
        isLoggedOut = true
    }
    
    private func deleteUser(){
        let user = Auth.auth().currentUser
        user?.delete() { error in
            if let error = error {
                print("Error deleting account")
                print(error)
                isDeletingAccount.toggle()
            } else {
                viewRouter.currentPage = .signInPage
                isLoggedOut = true
            }
        }
       
    }
    
    private func saveAllInfo(){
        if(editInfo == false){
            viewModel.updateUserProfile(updatedProfile: viewModel.userProfile) { (profileId) -> Void in
                if profileId != "" {
                    uploadStorageFile(image: viewModel.profileImage, profileId: viewModel.userProfile.id)
                }
            }
          
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
    
    private func nameSection(for geoReader: GeometryProxy) -> some View{
        HStack{
                Text("Name")
                    .foregroundColor(.white)
                    .font(.system(size: geoReader.size.width * 0.05))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            
            if(editInfo){
                TextField("", text: $viewModel.userProfile.fullName)
                    .foregroundColor(.black)
                    .frame(width: geoReader.size.width * 0.35, height: geoReader.size.height * 0.005)
                    .padding()
                    .background(.white)
                    .opacity(0.5)
                    .cornerRadius(geoReader.size.width * 0.03)
                    .textInputAutocapitalization(.never)
                    .overlay(
                        RoundedRectangle(cornerRadius: geoReader.size.width * 0.03).stroke(.white, lineWidth: 1)
                    )
            }else {
                Text(viewModel.userProfile.fullName == "" ? "Enter Name" : viewModel.userProfile.fullName)
                    .foregroundColor(Color.gray)
                    .font(.system(size: geoReader.size.height * 0.025))
                    .padding(.trailing,geoReader.size.height * 0.1)
            }
        }
    }
    
    private func pickerSections(for geoReader: GeometryProxy) -> some View{
        HStack{
                Text("Gender")
                    .foregroundColor(.white)
                    .font(.system(size: geoReader.size.width * 0.05))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            
            
            Menu {
                Picker(selection: $viewModel.userProfile.gender) {
                    ForEach(genderChoices, id: \.self) { choice in
                        Text("\(choice)")
                            .tag(choice)
                            .font(.system(size: geoReader.size.height * 0.04))
                    }
                } label: {}
            } label: {
                Text("\(viewModel.userProfile.gender)")
                    .font(.system(size: geoReader.size.height * 0.04))
            }
            .padding(.bottom,geoReader.size.height * 0.02)
            .padding(.trailing,geoReader.size.height * 0.1)
            .accentColor(.white)
            .disabled(editInfo == false)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
