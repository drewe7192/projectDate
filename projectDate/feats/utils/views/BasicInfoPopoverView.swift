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
    @Binding var isSearchingForRoom: Bool
    
    @ObservedObject var viewModel = HomeViewModel()
    
    @State private var genderChoices: [String] = ["Female","Male"]
    @State private var matchDayChoices: [String] = ["Saturday","Friday","Thursday","Wednesday","Tuesday","Monday","Sunday"]
    @State private var showImageSheet: Bool = false
    @State private var editInfo: Bool = false
    @State private var alertCompleteForm: Bool = false
    
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
            .interactiveDismissDisabled(true)
            .position(x: geoReader.frame(in: .local).midX, y:geoReader.frame(in: .local).midY)
            .alert(isPresented: $alertCompleteForm){
                Alert(
                    title: Text("Profile not complete"),
                    message: Text("Please complete all inputs")
                )
            }
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
        let isFormComplete =  profileImage.size.height != 0  &&
        userProfile.fullName != "" &&
        userProfile.gender != "Pick Gender"
        //userProfile.matchDay != "Pick MatchDay"
        
        if(editInfo && isFormComplete){
            viewModel.updateUserProfile(updatedProfile: userProfile) {(profileId) -> Void in
                if profileId != "" {
                    SettingsView().uploadStorageFile(image: profileImage, profileId: profileId)
                    showingInstructionsPopover.toggle()
                }
            }
        } else if (editInfo && isFormComplete == false) {
            self.alertCompleteForm = true
        }
    }
    
    private func uploadStorageFile(image: UIImage){
        let storageRef = storage.reference().child("\(String(describing: userProfile.id))"+"/images/image.jpg")
        
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
                Text("Lets Break the Ice!")
                    .foregroundColor(Color.iceBreakrrrBlue)
                    .font(.custom("Chalkduster", size: geoReader.size.height * 0.035))
                    .multilineTextAlignment(.center)
                
                Text("With this connect/friend app")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.system(size: geoReader.size.height * 0.028))
                    .padding(.bottom,5)

//                Text("IceBreakrrr")
//                    .foregroundColor(.iceBreakrrrBlue)
//                    .font(.custom("Chalkduster", size: geoReader.size.height * 0.030))
//                    .multilineTextAlignment(.center)
                  
                
                Spacer()
                    .frame(height: geoReader.size.height * 0.04)
                
                Text("Our cool features:")
                    .foregroundColor(Color.iceBreakrrrBlue)
                    .font(.custom("Chalkduster",size: geoReader.size.height * 0.035))
                    .multilineTextAlignment(.center)
                    .padding(.bottom,1)
                
                Text("Live Chat:")
                    .foregroundColor(.iceBreakrrrBlue)
                    .font(.system(size: geoReader.size.height * 0.028))
                    .multilineTextAlignment(.center)
                    .padding(2)

//                Text("join a chatRoom immediately and start SpeedDating")
//                    .foregroundColor(.white)
//                    .font(.system(size: geoReader.size.height * 0.025))
//                    .multilineTextAlignment(.center)
//                    .padding(.bottom,1)
//
//                Text("SpeedDate Sundays:")
//                    .foregroundColor(.iceBreakrrrBlue)
//                    .font(.system(size: geoReader.size.height * 0.028))
//                    .multilineTextAlignment(.center)
//                    .padding(.bottom,1)
//
//                Text("every Sunday schedule speedDates with your matches!")
//                    .foregroundColor(.white)
//                    .font(.system(size: geoReader.size.height * 0.025))
//                    .multilineTextAlignment(.center)
//                    .padding(.bottom,1)
            }
            
//            Group{
//                Text("Swipe Cards for better matches:")
//                    .foregroundColor(.iceBreakrrrBlue)
//                    .font(.system(size: geoReader.size.height * 0.028))
//                    .multilineTextAlignment(.center)
//                    .padding(.bottom,1)
//
//                Text("swipe cards while waiting for live speedDate to get unique speedDates")
//                    .foregroundColor(.white)
//                    .font(.system(size: geoReader.size.height * 0.025))
//                    .multilineTextAlignment(.center)
//                    .padding(.bottom,1)
//
////                HStack{
////                    Image(systemName: "snowflake.circle")
////                        .resizable()
////                        .frame(width: geoReader.size.width * 0.08, height: geoReader.size.height * 0.04)
////                        .foregroundColor(.white)
////
////                    Text(": Pick a day once a week to get matches")
////                        .foregroundColor(.white)
////                        .font(.system(size: geoReader.size.height * 0.025))
////                        .multilineTextAlignment(.center)
////                }
////                .padding(5)
////
////                Text("Meet via speed-dating video chats!")
////                    .foregroundColor(.white)
////                    .font(.system(size: geoReader.size.height * 0.025))
////                    .multilineTextAlignment(.center)
//
//                Text(" & more features on the way!")
//                    .foregroundColor(Color.iceBreakrrrBlue)
//                    .font(.custom("Chalkduster",size: geoReader.size.height * 0.035))
//                    .multilineTextAlignment(.center)
//                    .padding(.bottom,1)
//            }
            
            Spacer()
                .frame(height: geoReader.size.height * 0.03)
            
            Button(action: {
                showingBasicInfoPopover.toggle()
               // isSearchingForRoom.toggle()
                
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
            
            HStack{
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .frame(width: geoReader.size.width * 0.06, height: geoReader.size.height * 0.03)
                    .foregroundColor(profileImage.size.height != 0 ? .green : .mainGrey)
                
                Text("Add Image")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
            }
            
            
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
        VStack{
            HStack{
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .frame(width: geoReader.size.width * 0.06, height: geoReader.size.height * 0.03)
                    .foregroundColor(userProfile.fullName != "" ? .green : .mainGrey)
                
                Text("Name")
                    .foregroundColor(.white)
                    .font(.system(size: geoReader.size.width * 0.05))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            
            
            
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
            HStack{
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .frame(width: geoReader.size.width * 0.06, height: geoReader.size.height * 0.03)
                    .foregroundColor(userProfile.gender != "Pick Gender" ? .green : .mainGrey)
                
                Text("Gender")
                    .foregroundColor(.white)
                    .font(.system(size: geoReader.size.width * 0.05))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            
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
            
            
            
            //PREFERRED GENDER INPUT FUTURE FEATURE
//            HStack{
//                Image(systemName: "checkmark.circle")
//                    .resizable()
//                    .frame(width: geoReader.size.width * 0.06, height: geoReader.size.height * 0.03)
//                    .foregroundColor(userProfile.preferredGender != "Pick Gender" ? .green : .mainGrey)
//
//                Text("Your match's gender")
//                    .foregroundColor(.white)
//                    .font(.system(size: geoReader.size.width * 0.05))
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(.leading)
//
//            Menu {
//                Picker(selection: $userProfile.preferredGender) {
//                    ForEach(genderChoices, id: \.self) { choice in
//                        Text("\(choice)")
//                            .tag(choice)
//                            .font(.system(size: geoReader.size.height * 0.04))
//                    }
//                } label: {}
//            } label: {
//                Text("\(userProfile.preferredGender)")
//                    .font(.system(size: geoReader.size.height * 0.04))
//            }
//            .padding(.bottom,geoReader.size.height * 0.02)
//            .accentColor(.white)
//            .disabled(editInfo == false)
            
            
//            HStack{
//                Image(systemName: "checkmark.circle")
//                    .resizable()
//                    .frame(width: geoReader.size.width * 0.06, height: geoReader.size.height * 0.03)
//                    .foregroundColor(userProfile.matchDay != "Pick MatchDay" ? .green : .mainGrey)
//
//                Text("MatchDay")
//                    .foregroundColor(.white)
//                    .font(.system(size: geoReader.size.width * 0.05))
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(.leading)
//
//            Menu {
//                Picker(selection: $userProfile.matchDay) {
//                    ForEach(matchDayChoices, id: \.self) { matchDay in
//                        Text("\(matchDay)")
//                        // .tag(matchDay)
//                            .font(.system(size: geoReader.size.height * 0.01))
//                    }
//                } label: {}
//            } label: {
//                HStack{
//                    Image(systemName: "snowflake.circle")
//                        .resizable()
//                        .frame(width: geoReader.size.width * 0.08, height: geoReader.size.height * 0.04)
//                        .foregroundColor(editInfo ? .white : .mainGrey)
//
//                    Text("\(userProfile.matchDay)")
//                        .font(.system(size: geoReader.size.height * 0.04))
//                }
//            }
//            .accentColor(.white)
//            .disabled(editInfo == false)
        }
    }
    
    private func basicInfoButton(for geoReader: GeometryProxy) -> some View{
        VStack{
            Button(action: {
                saveAllInfo()
                editInfo.toggle()
           
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
        BasicInfoPopoverView(userProfile: .constant(ProfileModel(id: "", fullName: "", location: "", gender: "Pick gender", matchDay: "Pick MatchDay", messageThreadIds: [], speedDateIds: [], fcmTokens: [], preferredGender: "Pick gender", currentRoomId: "")), profileImage: .constant(UIImage()), showingBasicInfoPopover: .constant(false), showingInstructionsPopover: .constant(true), isSearchingForRoom: .constant(false))
    }
}
