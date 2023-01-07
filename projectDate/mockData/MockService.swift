//
//  MockService.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/29/22.
//

import Foundation

enum MockService {
    
    static var homeTabTitles: Array = ["Top-Rated", "Recommended",  "Upcoming"]
    static var profileSampleData: ProfileModel {
        ProfileModel(firstName: "vooon",
                     lastName: "Daooy", location: "Tampa, Fl",profileType: "recommended", images: ["animeGirl","animeGirl2","sasuke"],
                     info: ProfileInfoModel(
                        aboutMe: "fdsfsdfs",
                        interests: "fdsfadsfdsfdsfaddsf",
                        sideBarInfo: sideBarInfoModel(height: "6ft", isSmoke: true, isKids: false)
                     ), test: 1)
    }
    
    static var sdSampleData: sdModel {
        sdModel(firstName: "Drew",
                lastName: "Drew",
                time: 4743843,
                userRoleType: "host",
                roomNumber: "638d9e07aee54625da64dfe2",
                profiles: profilesSampleData)
    }
    
    static var profilesSampleData: [ProfileModel] {
        [
            ProfileModel(
                firstName: "Travon",
                lastName: "Dayvon",
                location: "ClearWater, Fl",
                profileType: "top-rated",
                images: ["animeGirl","animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf",
                                       sideBarInfo: sideBarInfoModel(height: "6ft", isSmoke: true, isKids: false)
                                      ),test: 1),
            ProfileModel(
                firstName: "von",
                lastName: "Day",
                location: "Tampa, Fl",
                profileType: "recommended",
                images: ["animeGirl","animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf",
                                       sideBarInfo: sideBarInfoModel(height: "6ft", isSmoke: true, isKids: false)
                                      ),test: 1),
            ProfileModel(
                firstName: "22Gz",
                lastName: "Blixy",
                location: "St.Pete, Fl",
                profileType: "top-rated",
                images: ["animeGirl","animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfsbbgfgf", interests: "fdsfadsfdsfdsfaddsf",
                                       sideBarInfo: sideBarInfoModel(height: "6ft", isSmoke: true, isKids: false)
                                      ),test: 2),
            ProfileModel(
                firstName: "Felippe",
                lastName: "Ferriera",
                location: "Tally, Fl",
                profileType: "like",
                images: ["animeGirl","animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf",
                                       sideBarInfo: sideBarInfoModel(height: "6ft", isSmoke: true, isKids: false)
                                      ),test: 1),
            ProfileModel(
                firstName: "Sierra",
                lastName: "AppleWhite",
                location: "ClearWater, Fl",
                profileType: "recommended",
                images: ["animeGirl","animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs",interests: "fdsfadsfdsfdsfaddsf",
                                       sideBarInfo: sideBarInfoModel(height: "6ft", isSmoke: true, isKids: false)
                                      ),test: 1),
            ProfileModel(
                firstName: "Ashley",
                lastName: "Bashely",
                location: "ClearWater, Fl",
                profileType: "match",
                images: ["animeGirl","animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf",
                                       sideBarInfo: sideBarInfoModel(height: "6ft", isSmoke: true, isKids: false)
                                      ),test: 2),
            ProfileModel(
                firstName: "My",
                lastName: "Dude",
                location: "ClearWater, Fl",
                profileType: "top-rated",
                images: ["animeGirl","animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf",
                                       sideBarInfo: sideBarInfoModel(height: "6ft", isSmoke: true, isKids: false)
                                      ),test: 1),
            ProfileModel(
                firstName: "Travon",
                lastName: "Dayvon",
                location: "ClearWater, Fl",
                profileType: "recommended",
                images: ["animeGirl","animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf",
                                       sideBarInfo: sideBarInfoModel(height: "6ft", isSmoke: true, isKids: false)
                                      ),test: 1),
            ProfileModel(
                firstName: "Travon",
                lastName: "Dayvon",
                location: "ClearWater, Fl",
                profileType: "top-rated",
                images: ["animeGirl","animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf",
                                       sideBarInfo: sideBarInfoModel(height: "6ft", isSmoke: true, isKids: false)
                                      ),test: 2),
            
        ]
    }
    
    static var userSampleData: UserModel {
        UserModel(
            firstName: "Travon",
            lastName: "Dayvon", location: "ClearWater, Fl",
            sds:  [
                sdModel(
                    firstName: "Drew",
                    lastName: "Drew",
                    time: 172805,
                    userRoleType: "host",
                    roomNumber: "638d9e07aee54625da64dfe2",
                    profiles: profilesSampleData
                ),
                sdModel(
                    firstName: "D",
                    lastName: "ew",
                    time: 384585,
                    userRoleType: "guest",
                    roomNumber: "638d9e07aee54625da64dfe2",
                    profiles: profilesSampleData
                ),
                sdModel(
                    firstName: "w",
                    lastName: "w",
                    time: 5059448,
                    userRoleType: "host",
                    roomNumber: "638d9e07aee54625da64dfe2",
                    profiles: profilesSampleData
                )
            ],
            Profiles: profilesSampleData
        )
    }
}
