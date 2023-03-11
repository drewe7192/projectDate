//
//  BasicInfoPopoverView.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/11/23.
//

import SwiftUI

struct BasicInfoPopoverView: View {
    @Binding var basicInfoPopover: Bool
    @Binding var userProfile: ProfileModel
    @State private var selectedChoice = "Pick gender"
    @State private var genderChoices: [String] = ["Female","Male"]
    @State private var showImageSheet = false
    @State private var profileImage: UIImage = UIImage()
    
    var body: some View {
        GeometryReader{geoReader in
            ZStack{
                Color.mainBlack
                    .ignoresSafeArea()
                
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
                    
                    
                    
                    Spacer()
                        .frame(height: 100)
                    
                    Button(action: {
                        HomeView().updateUserProfile(updatedProfile: userProfile) {(profileId) -> Void in
                            if profileId != "" {
                                SettingsView().uploadStorageFile(image: self.profileImage)
                                basicInfoPopover.toggle()
                            }
                        }
                        
                    }) {
                        Text("Save")
                            .bold()
                            .frame(width: 300, height: 70)
                            .background(Color.iceBreakrrrPink)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(radius: 8, x: 10, y:10)
                    }
                }
                .sheet(isPresented: $showImageSheet){
                    // Pick an image from the photo library:
                    ImagePicker(sourceType: .photoLibrary, selectedImage: $profileImage)
                    
                    //  If you wish to take a photo from camera instead:
                    // ImagePicker(sourceType: .camera, selectedImage: self.$image)
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

struct BasicInfoPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        BasicInfoPopoverView(basicInfoPopover: .constant(false), userProfile: .constant(ProfileModel(id: "", fullName: "", location: "", gender: "Pick gender")))
    }
}
