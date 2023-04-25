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
    @Binding var profileImage: UIImage
    @Binding var showingBasicInfoPopover: Bool
    @Binding var showingInstructionsPopover: Bool
    
    @ObservedObject var viewModel = HomeViewModel()
    
    @State private var genderChoices: [String] = ["Female","Male"]
    @State private var matchDayChoices: [String] = ["Saturday","Friday","Thursday","Wednesday","Tuesday","Monday","Sunday"]
    @State private var showImageSheet: Bool = false
    @State private var editInfo: Bool = false
    
    let storage = Storage.storage()
    
    var body: some View {
        GeometryReader{geoReader in
            ZStack{
                Color.mainBlack
                    .ignoresSafeArea()
                
                if(!showingInstructionsPopover){
                    basicInfoPopover(for: geoReader)
                } else {
                    instructionsPopover(for: geoReader)
                }
            }
            .position(x: geoReader.frame(in: .local).midX, y:geoReader.frame(in: .local).midY)
        }
    }
    
    private func imageSection(for geoReader: GeometryProxy) -> some View {
        VStack{
            Image(uiImage: profileImage)
                .resizable()
                .frame(width: 150, height: 150)
                .background(Color.black.opacity(0.2))
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
            
            if(editInfo) {
                Button(action: {
                    showImageSheet = true
                }) {
                    Text("Upload Image")
                        .font(.headline)
                        .frame(width: geoReader.size.width * 0.6, height: geoReader.size.height * 0.04)
                        .background(Color.mainGrey)
                        .cornerRadius(geoReader.size.height * 0.04)
                        .shadow(radius: 10, x: 10, y: 10)
                        .foregroundColor(Color.iceBreakrrrBlue)
                }
                
            }
            
        }
    }
    
    private func saveAllInfo(){
        if(editInfo == false){
            viewModel.updateUserProfile(updatedProfile: userProfile) {(profileId) -> Void in
                if profileId != "" {
                    SettingsView().uploadStorageFile(image: profileImage, profileId: profileId)
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
    
    private func instructionsPopover(for geoReader: GeometryProxy) -> some View{
        VStack(spacing: geoReader.size.height * 0.01){
            
            Group {
                Text("Welcome to IceBreakrrr!")
                    .foregroundColor(Color.iceBreakrrrBlue)
                    .font(.custom("Chalkduster", size: geoReader.size.height * 0.045))
                    .multilineTextAlignment(.center)
                
                Text("Yupp: this is another dating app..")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.system(size: geoReader.size.height * 0.025))
                    .padding(.bottom,5)
                
                Text("But this focuses more on matching values & personalities")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.system(size: geoReader.size.height * 0.025))
                
                Spacer()
                    .frame(height: geoReader.size.height * 0.04)
                
                Text("Here's how it works:")
                    .foregroundColor(Color.iceBreakrrrBlue)
                    .font(.custom("Chalkduster",size: geoReader.size.height * 0.04))
                    .multilineTextAlignment(.center)
                    .padding(.bottom,1)
                
                Text("Answer questions on each card based on how you would like your perfect match to answer")
                    .foregroundColor(.white)
                    .font(.system(size: geoReader.size.height * 0.025))
                    .multilineTextAlignment(.center)
                    .padding(2)
                
                Text("Submit card by swiping right, skip card by swiping left")
                    .foregroundColor(.white)
                    .font(.system(size: geoReader.size.height * 0.025))
                    .multilineTextAlignment(.center)
                    .padding(.bottom,1)
                
                Text("Swipe at least 20 cards to get a match")
                    .foregroundColor(.white)
                    .font(.system(size: geoReader.size.height * 0.025))
                    .multilineTextAlignment(.center)
                    .padding(.bottom,1)
            }
            
            Group{
                Text("Create your own cards via plus button")
                    .foregroundColor(.white)
                    .font(.system(size: geoReader.size.height * 0.025))
                    .multilineTextAlignment(.center)
                    .padding(.bottom,1)
             
                HStack{
                    Image(systemName: "snowflake.circle")
                        .resizable()
                        .frame(width: geoReader.size.width * 0.08, height: geoReader.size.height * 0.04)
                        .foregroundColor(.white)
                    
                    Text(": Pick a day once a week to get matches")
                        .foregroundColor(.white)
                        .font(.system(size: geoReader.size.height * 0.025))
                        .multilineTextAlignment(.center)
                }
                .padding(5)
                
                Text("Meet via speed-dating video chats!")
                    .foregroundColor(.white)
                    .font(.system(size: geoReader.size.height * 0.025))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
                .frame(height: geoReader.size.height * 0.03)
            
            Button(action: {
                showingBasicInfoPopover.toggle()
            }) {
                Text("Got it")
                    .bold()
                    .frame(width: geoReader.size.width * 0.7, height: geoReader.size.height * 0.1)
                    .background(Color.mainGrey)
                    .foregroundColor(Color.iceBreakrrrBlue)
                    .font(.system(size: geoReader.size.height * 0.035))
                    .cornerRadius(geoReader.size.height * 0.04)
                    .shadow(radius: geoReader.size.width * 0.02, x: geoReader.size.width * 0.04, y: geoReader.size.width * 0.04)
            }
        }
    }
    
    private func basicInfoPopover(for geoReader: GeometryProxy) -> some View{
        VStack(spacing: geoReader.size.width * 0.02){
            Text("Create Profile")
                .foregroundColor(.white)
                .font(.system(size: geoReader.size.width * 0.1))
                .multilineTextAlignment(.center)
            
            Spacer()
                .frame(height: geoReader.size.width * 0.05)
            
            imageSection(for: geoReader)
            
            Spacer()
                .frame(height: geoReader.size.width * 0.07)
            
            nameSection(for: geoReader)
            
            Spacer()
                .frame(height: geoReader.size.height * 0.02)
            
            pickerSections(for: geoReader)
            
            Spacer()
                .frame(height: geoReader.size.height * 0.05)
            
            basicInfoButton(for: geoReader)
        }
        .sheet(isPresented: $showImageSheet){
            // Pick an image from the photo library:
            ImagePicker(sourceType: .photoLibrary, selectedImage: $profileImage)
            
            //  If you wish to take a photo from camera instead:
            // ImagePicker(sourceType: .camera, selectedImage: self.$image)
        }
    }
    
    private func nameSection(for geoReader: GeometryProxy) -> some View{
        HStack{
            Text("Name")
                .foregroundColor(.white)
                .font(.system(size: geoReader.size.width * 0.07))
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
                        RoundedRectangle(cornerRadius: geoReader.size.width * 0.03).stroke(.white, lineWidth: 1)
                    )
            }else {
                Text(userProfile.fullName == "" ? "Enter Name" : userProfile.fullName)
                    .foregroundColor(Color.gray)
                    .font(.system(size: geoReader.size.height * 0.025))
            }
        }
    }
    
    private func pickerSections(for geoReader: GeometryProxy) -> some View{
        VStack{
            Menu {
                Picker(selection: $userProfile.gender) {
                    ForEach(genderChoices, id: \.self) { choice in
                        Text("\(choice)")
                            .tag(choice)
                            .font(.system(size: geoReader.size.height * 0.04))
                    }
                } label: {}
            } label: {
                Text("\(userProfile.gender)")
                    .font(.system(size: geoReader.size.height * 0.04))
            }
            .padding(.bottom,geoReader.size.height * 0.02)
            .accentColor(.white)
            .disabled(editInfo == false)
            
            Menu {
                Picker(selection: $userProfile.matchDay) {
                    ForEach(matchDayChoices, id: \.self) { matchDay in
                        Text("\(matchDay)")
                           // .tag(matchDay)
                            .font(.system(size: geoReader.size.height * 0.01))
                    }
                } label: {}
            } label: {
                HStack{
                    Image(systemName: "snowflake.circle")
                        .resizable()
                        .frame(width: geoReader.size.width * 0.08, height: geoReader.size.height * 0.04)
                        .foregroundColor(editInfo ? .white : .mainGrey)
                    
                    Text("\(userProfile.matchDay)")
                        .font(.system(size: geoReader.size.height * 0.04))
                }
            }
            .accentColor(.white)
            .disabled(editInfo == false)
            
            Text("(pick day to get matches)")
                .foregroundColor(.iceBreakrrrBlue)
        }
    }
    
    private func basicInfoButton(for geoReader: GeometryProxy) -> some View{
        VStack{
            Button(action: {
                editInfo.toggle()
                saveAllInfo()
            }) {
                Text(editInfo ? "Save" : "Edit Profile")
                    .bold()
                    .font(.system(size: geoReader.size.height * 0.035))
                    .foregroundColor(.iceBreakrrrBlue)
                    .frame(width: geoReader.size.width * 0.7, height: geoReader.size.height * 0.1)
                    .background(Color.mainGrey)
                    .cornerRadius(geoReader.size.width * 0.04)
                    .shadow(radius: geoReader.size.width * 0.02, x: geoReader.size.width * 0.04, y: geoReader.size.width * 0.04)
            }
        }
    }
}

struct BasicInfoPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        BasicInfoPopoverView(userProfile: .constant(ProfileModel(id: "", fullName: "", location: "", gender: "Pick gender", matchDay: " Pick Day", messageThreadIds: [], speedDateIds: [])), profileImage: .constant(UIImage()), showingBasicInfoPopover: .constant(false), showingInstructionsPopover: .constant(false))
    }
}
