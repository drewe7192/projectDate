//
//  BasicInfoPopoverView.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/11/23.
//

import SwiftUI
import FirebaseStorage
import FirebaseAuth


struct BasicInfoPopoverView: View {
    @Binding var userProfile: ProfileModel
    @Binding var showingBasicInfoPopover: Bool
    @Binding var showingInstructionsPopover: Bool
    
    @State private var selectedChoice = "Pick gender"
    @State private var genderChoices: [String] = ["Female","Male"]
    @State private var showImageSheet = false
    @State private var profileImage: UIImage = UIImage()
    @State private var editInfo = false
    
    let storage = Storage.storage()
    
    var body: some View {
        GeometryReader{geoReader in
            ZStack{
                Color.mainBlack
                    .ignoresSafeArea()
                
                if(!showingInstructionsPopover){
                    VStack(spacing: 10){
                        Text("Basic information:")
                            .foregroundColor(.white)
                            .font(.system(size: 35))
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                            .frame(height: 10)
                        
                        imageSection(for: geoReader)
                        
                        Spacer()
                            .frame(height: 30)
                        
                        HStack{
                            Text("Name")
                                .foregroundColor(.white)
                                .font(.system(size: 25))
                                .padding(.trailing, geoReader.size.width * 0.15)
                            
                            
                            if(editInfo){
                                TextField("", text: $userProfile.fullName)
                                    .foregroundColor(.black)
                                    .frame(width: geoReader.size.width * 0.35, height: geoReader.size.height * 0.005)
                                    .padding()
                                    .background(.white)
                                    .opacity(0.5)
                                    .cornerRadius(geoReader.size.width * 0.03)
                                    .textInputAutocapitalization(.never)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 1)
                                    )
                            }else {
                                Text(userProfile.fullName == "" ? "Enter Name" : "yo")
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: geoReader.size.height * 0.025))
                            }
                            
                     
                        }
                        
                        Spacer()
                            .frame(height: 10)
                        
                        Menu {
                            Picker(selection: $userProfile.gender) {
                                ForEach(genderChoices, id: \.self) { choice in
                                    Text("\(choice)")
                                        .tag(choice)
                                        .font(.system(size: 40))
                                }
                            } label: {}
                        } label: {
                            Text("\(userProfile.gender)")
                                .font(.system(size: 30))
                        }
                        .accentColor(.white)
                        .disabled(editInfo == false)
                        
                        Spacer()
                            .frame(height: 100)
                        
                        Button(action: {
                            editInfo.toggle()
                            saveAllInfo()
                        }) {
                            Text(editInfo ? "Save" : "Edit Profile")
                                .bold()
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                                .frame(width: geoReader.size.width * 0.7, height: geoReader.size.height * 0.08)
                                .background(Color.iceBreakrrrPink)
                                .cornerRadius(geoReader.size.width * 0.04)
                                .shadow(radius: geoReader.size.width * 0.02, x: geoReader.size.width * 0.04, y: geoReader.size.width * 0.04)
                            
                        }
                    }
                    .sheet(isPresented: $showImageSheet){
                        // Pick an image from the photo library:
                        ImagePicker(sourceType: .photoLibrary, selectedImage: $profileImage)
                        
                        //  If you wish to take a photo from camera instead:
                        // ImagePicker(sourceType: .camera, selectedImage: self.$image)
                    }
                } else {
                    
                    VStack(spacing: 10){
                        Text("Welcome to IceBreakrrr:")
                            .foregroundColor(.white)
                            .font(.system(size: 35))
                            .multilineTextAlignment(.center)
                        
                        Text("the dating app where you're the Matchmaker!")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 25))
                        
                        Spacer()
                            .frame(height: 30)
                        
                        
                        Text("Here's how it works:")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .multilineTextAlignment(.center)
                            .padding(.bottom,5)
                        
                        Text("- Answer the questions")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .multilineTextAlignment(.center)
                        
                        Text("- Swipe the cards")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .multilineTextAlignment(.center)
                        
                        Text("- Every week get a match")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .multilineTextAlignment(.center)
                        
                        Text("- Meet match via biWeekly events in the Events tab!")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                            .frame(height: 100)
                        
                        Button(action: {
                            showingBasicInfoPopover.toggle()
                        }) {
                            Text("Got it")
                                .bold()
                                .frame(width: 300, height: 70)
                                .background(Color.iceBreakrrrPink)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .shadow(radius: 8, x: 10, y:10)
                        }
                    }
                }
            }
        }
    }
    
    private func imageSection(for geoReader: GeometryProxy) -> some View {
        VStack{
            Image(uiImage: self.profileImage)
                .resizable()
                .cornerRadius(50)
                .frame(width: 200, height: 200)
                .background(Color.black.opacity(0.2))
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
            
            if(editInfo) {
                Button(action: {
                    showImageSheet = true
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
    
    private func saveAllInfo(){
        if(editInfo == false){
            HomeView().updateUserProfile(updatedProfile: userProfile) {(profileId) -> Void in
                if profileId != "" {
                    SettingsView().uploadStorageFile(image: self.profileImage)
                    showingInstructionsPopover.toggle()
                }
            }
        }
    }
    
    private func uploadStorageFile(image: UIImage){
        let storageRef = storage.reference().child("\(String(describing: Auth.auth().currentUser?.uid))"+"/images/image.jpg")
        
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
}

struct BasicInfoPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        BasicInfoPopoverView(userProfile: .constant(ProfileModel(id: "", fullName: "", location: "", gender: "Pick gender")), showingBasicInfoPopover: .constant(false), showingInstructionsPopover: .constant(false))
    }
}
