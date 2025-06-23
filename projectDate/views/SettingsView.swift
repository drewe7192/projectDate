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
    @EnvironmentObject var viewModel: ProfileViewModel
    //  @StateObject var viewModel = LiveViewModel()
    
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
            VStack{
                headerSection()
                
                Spacer()
                
                imageSection()
                
                Spacer()
                
                nameSection()
                
                Spacer()
                
               // pickerSections()
                buttonsSection()
                
                Spacer()
            }
            .onAppear{
                //                    viewModel.getUserProfile(){(profileId) -> Void in
                //                        if profileId != "" {
                //                            viewModel.getStorageFile(profileId: profileId)
                //                        }
                //                    }
            }
            .alert(isPresented: $isDeletingAccount){
                Alert(
                    title: Text("Error deleting account"),
                    message: Text("This operation is sensitive and requires recent authentication. Log in again before retrying this request")
                )
            }
            .sheet(isPresented: $showSheet){
                // Pick an image from the photo library:
                
                //  If you wish to take a photo from camera instead:
                // ImagePicker(sourceType: .camera, selectedImage: self.$image)
            }
    }
    
    private func imageSection() -> some View {
        VStack{
            if true {
                ZStack {
                    Circle()
                        .fill(Color.secondaryColor)
                        .overlay {
                            Image(uiImage: viewModel.userProfile.profileImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 180, height: 180)
                                .clipShape(Circle())
                        }
                        .frame(width: 200, height: 200)
                }
                
           
            } else {
                Circle()
                    .fill(Color.secondaryColor)
                    .frame(width: 200, height: 200)
            }
            
            if(editInfo){
                Button(action: {
                    showSheet = true
                }) {
                    Text("Upload Image")
                        .font(.headline)
                        .frame(width: 250)
                        .frame(height: 50)
                        .background(Color.secondaryColor)
                        .cornerRadius(40)
                        .shadow(radius: 10, x: 10, y: 10)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                }
            }
        }
    }
    
    private func buttonsSection() -> some View {
        VStack{
            Button(action: {
                editInfo.toggle()
                //  saveAllInfo()
            }) {
                Text(editInfo ? "Save Profile" : "Edit Profile")
                    .foregroundColor(.white)
                    .frame(width: 350, height: 60)
                    .background(Color.secondaryColor)
                    .cornerRadius(40)
            }
            
            Button(action: {
                signOutUser()
            }) {
                Text("Sign Out")
                    .foregroundColor(.white)
                    .frame(width: 350, height: 60)
                    .background(Color.secondaryColor)
                    .cornerRadius(40)
            }
            
            Button(action: {
                deleteUser()
            }) {
                Text("DELETE ACCOUNT")
                    .foregroundColor(.red)
                    .frame(width: 350, height: 60)
                    .background(Color.secondaryColor)
                    .cornerRadius(40)
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
    //    private func saveAllInfo(){
    //        if(editInfo == false){
    //            viewModel.updateUserProfile(updatedProfile: viewModel.userProfile) { (profileId) -> Void in
    //                if profileId != "" {
    //                    uploadStorageFile(image: viewModel.profileImage, profileId: viewModel.userProfile.id)
    //                }
    //            }
    //
    //        }
    //    }
    
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
    
    private func headerSection() -> some View {
        HStack{
            Text("Settings")
                .foregroundColor(Color.black)
                .bold()
                .font(.system(size: 30))
                .padding()
            
            Spacer()
            
            Circle()
                .frame(width: 35)
                .overlay {
                    Image(systemName: "line.3.horizontal.decrease")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                }
                .padding()
                .foregroundColor(.gray)
        }
    }
    
    private func nameSection() -> some View{
        HStack{
            Text("Name")
                .foregroundColor(.white)
                .font(.system(size: 30))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            
            if(editInfo){
                //                TextField("", text: $viewModel.userProfile.fullName)
                //                    .foregroundColor(.black)
                //                    .frame(width: geoReader.size.width * 0.35, height: geoReader.size.height * 0.005)
                //                    .padding()
                //                    .background(.white)
                //                    .opacity(0.5)
                //                    .cornerRadius(geoReader.size.width * 0.03)
                //                    .textInputAutocapitalization(.never)
                //                    .overlay(
                //                        RoundedRectangle(cornerRadius: geoReader.size.width * 0.03).stroke(.white, lineWidth: 1)
                //                    )
            }else {
                //                Text(viewModel.userProfile.fullName == "" ? "Enter Name" : viewModel.userProfile.fullName)
                //                    .foregroundColor(Color.gray)
                //                    .font(.system(size: geoReader.size.height * 0.025))
                //                    .padding(.trailing,geoReader.size.height * 0.1)
            }
        }
    }
    
    private func pickerSections() -> some View{
        HStack{
            Text("Gender")
                .foregroundColor(.white)
                .font(.system(size: 10))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            //            Menu {
            //                Picker(selection: $viewModel.userProfile.gender) {
            //                    ForEach(genderChoices, id: \.self) { choice in
            //                        Text("\(choice)")
            //                            .tag(choice)
            //                            .font(.system(size: geoReader.size.height * 0.04))
            //                    }
            //                } label: {}
            //            } label: {
            ////                Text("\(viewModel.userProfile.gender)")
            ////                    .font(.system(size: geoReader.size.height * 0.04))
            //            }
            //            .padding(.bottom,geoReader.size.height * 0.02)
            //            .padding(.trailing,geoReader.size.height * 0.1)
            //            .accentColor(.white)
            //            .disabled(editInfo == false)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
