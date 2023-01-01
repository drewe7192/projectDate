//
//  MockService.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/29/22.
//

import Foundation

enum MockService {
    
    static var profileSampleData: ProfileModel {
        ProfileModel(firstName: "vooon",
                     lastName: "Daooy", location: "Tampa, Fl",profileType: "recommended", images: ["animeGirl","animeGirl2","sasuke"],info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf") )
    }
    
    static var profilesSampleData: [ProfileModel] {
        [
            ProfileModel(
                firstName: "Travon",
                lastName: "Dayvon",
                location: "ClearWater, Fl",
                profileType: "top-rated",
                images: ["animeGirl","animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf")),
            ProfileModel(
                firstName: "von",
                lastName: "Day",
                location: "Tampa, Fl",
                profileType: "recommended",
                images: ["animeGirl","animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf")),
            ProfileModel(
                firstName: "22Gz",
                lastName: "Blixy",
                location: "St.Pete, Fl",
                profileType: "top-rated",
                images: ["animeGirl","animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfsbbgfgf", interests: "fdsfadsfdsfdsfaddsf")),
            ProfileModel(
                firstName: "Felippe",
                lastName: "Ferriera",
                location: "Tally, Fl",
                profileType: "like",
                images: ["animeGirl","animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf")),
            ProfileModel(
                firstName: "Sierra",
                lastName: "AppleWhite",
                location: "ClearWater, Fl",
                profileType: "recommended",
                images: ["animeGirl","animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs",interests: "fdsfadsfdsfdsfaddsf")),
            ProfileModel(
                firstName: "Ashley",
                lastName: "Bashely",
                location: "ClearWater, Fl",
                profileType: "match",
                images: ["animeGirl","animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf")),
            ProfileModel(
                firstName: "My",
                lastName: "Dude",
                location: "ClearWater, Fl",
                profileType: "top-rated",
                images: ["animeGirl","animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf")),
            ProfileModel(
                firstName: "Travon",
                lastName: "Dayvon",
                location: "ClearWater, Fl",
                profileType: "recommended",
                images: ["animeGirl","animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf")),
            ProfileModel(
                firstName: "Travon",
                lastName: "Dayvon",
                location: "ClearWater, Fl",
                profileType: "top-rated",
                images: ["animeGirl","animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf")),
            
        ]
    }
    
    static var userSampleData: User {
        User(
            firstName: "Travon",
            lastName: "Dayvon", location: "ClearWater, Fl",
            sdTimes:  [
                sdTimeModel(
                    firstName: "Drew",
                    lastName: "Drew",
                    time: "August 12, 2023 5:30pm",
                    userRoleType: "host"
                ),
                sdTimeModel(
                    firstName: "D",
                    lastName: "ew",
                    time: "August 12, 2023 3:30pm",
                    userRoleType: "guest"
                ),
                sdTimeModel(
                    firstName: "w",
                    lastName: "w",
                    time: "August 12, 2023 4:30pm",
                    userRoleType: "host"
                )
            ],
            Profiles: profilesSampleData
        )
    }
}
