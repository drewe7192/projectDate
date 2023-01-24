//
//  MockService.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/29/22.
//

import Foundation

enum MockService {
    
    static var homeTabTitles: Array = ["Top-Rated", "Recommended",  "Upcoming"]
    
    static var userSampleData: UserModel {
        UserModel(
            firstName: "Travon",
            lastName: "Dayvon",
            email: "bob@google.com",
            location: "ClearWater, Fl",
            sds:  sdsSampleData,
            profiles: profilesSampleData
        )
    }
    
    static var sdSampleData: sdModel {
        sdModel(
            firstName: "Drew",
            lastName: "Drew",
            time: 4743843,
            userRoleType: "host",
            roomNumber: "638d9e07aee54625da64dfe2",
            profiles: profilesSampleData
        )
    }
    
    static var sdsSampleData: [sdModel] {
        [
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
                firstName: "D",
                lastName: "ew",
                time: 384585,
                userRoleType: "guest",
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
            )
        ]
    }
    
    static var profileSampleData: ProfileModel {
        ProfileModel(
            id: 1,
            firstName: "vooon",
            lastName: "Daooy", location: "Tampa, Fl",profileType: "recommended", images: ["animeGirl","animeGirl2","sasuke"],
            info: ProfileInfoModel(
            aboutMe: "fdsfsdfs",
            interests: "fdsfadsfdsfdsfaddsf",
            sideBarInfo: sideBarInfoModel(height: "6ft", isSmoke: true, isKids: false)),
            test: 1
        )
    }
    
    static var profilesSampleData: [ProfileModel] {
        [
            ProfileModel(
                id: 1,
                firstName: "Travon",
                lastName: "Dayvon",
                location: "ClearWater, Fl",
                profileType: "top-rated",
                images: ["animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf",
                                       sideBarInfo: sideBarInfoModel(height: "6ft", isSmoke: true, isKids: false)
                                      ),test: 1),
            ProfileModel(
                id: 2,
                firstName: "von",
                lastName: "Day",
                location: "Tampa, Fl",
                profileType: "recommended",
                images: ["sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf",
                                       sideBarInfo: sideBarInfoModel(height: "6ft", isSmoke: true, isKids: false)
                                      ),test: 1),
            ProfileModel(
                id: 3,
                firstName: "22Gz",
                lastName: "Blixy",
                location: "St.Pete, Fl",
                profileType: "top-rated",
                images: ["animeGirl","animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfsbbgfgf", interests: "fdsfadsfdsfdsfaddsf",
                                       sideBarInfo: sideBarInfoModel(height: "6ft", isSmoke: true, isKids: false)
                                      ),test: 2),
            ProfileModel(
                id: 4,
                firstName: "Felippe",
                lastName: "Ferriera",
                location: "Tally, Fl",
                profileType: "like",
                images: ["animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf",
                                       sideBarInfo: sideBarInfoModel(height: "6ft", isSmoke: true, isKids: false)
                                      ),test: 1),
            ProfileModel(
                id: 5,
                firstName: "Sierra",
                lastName: "AppleWhite",
                location: "ClearWater, Fl",
                profileType: "recommended",
                images: ["sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs",interests: "fdsfadsfdsfdsfaddsf",
                                       sideBarInfo: sideBarInfoModel(height: "6ft", isSmoke: true, isKids: false)
                                      ),test: 1),
            ProfileModel(
                id: 6,
                firstName: "Ashley",
                lastName: "Bashely",
                location: "ClearWater, Fl",
                profileType: "match",
                images: ["animeGirl","animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf",
                                       sideBarInfo: sideBarInfoModel(height: "6ft", isSmoke: true, isKids: false)
                                      ),test: 2),
            ProfileModel(
                id: 7,
                firstName: "My",
                lastName: "Dude",
                location: "ClearWater, Fl",
                profileType: "top-rated",
                images: ["animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf",
                                       sideBarInfo: sideBarInfoModel(height: "6ft", isSmoke: true, isKids: false)
                                      ),test: 1),
            ProfileModel(
                id: 8,
                firstName: "Travon",
                lastName: "Dayvon",
                location: "ClearWater, Fl",
                profileType: "recommended",
                images: ["animeGirl","animeGirl2","sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf",
                                       sideBarInfo: sideBarInfoModel(height: "6ft", isSmoke: true, isKids: false)
                                      ),test: 1),
            ProfileModel(
                id: 9,
                firstName: "Travon",
                lastName: "Dayvon",
                location: "ClearWater, Fl",
                profileType: "top-rated",
                images: ["sasuke"],
                info: ProfileInfoModel(aboutMe: "fdsfsdfs", interests: "fdsfadsfdsfdsfaddsf",
                                       sideBarInfo: sideBarInfoModel(height: "6ft", isSmoke: true, isKids: false)
                                      ),test: 2),
            
        ]
    }
    
    static var cardObjectSampleData: CardsModel {
        CardsModel(id: 0, cards: cardsSampleData)
    }
    
    static var cardsSampleData: [CardModel] {
        [
            CardModel(id: 0, question: "What is the first thing you do in the morning?", choices: ["What is that one piece of advice you would give to people to stop hatred?","fwarefaefesd","fdsfdsafdsf"], category: "qualities"),
            CardModel(id: 1, question: "What excites you the most in life?", choices: ["What is that one piece of advice you would give to people to stop hatred?","fwarefaefesd","fdsfdsafdsf"], category: "qualities"),
            CardModel(id: 2, question: "What is the first thing you do in the morning?", choices: ["What is that one piece of advice you would give to people to stop hatred?","fwarefaefesd","fdsfdsafdsf"], category: "qualities"),
            CardModel(id: 3, question: "What excites you the most in life?", choices: ["What is that one piece of advice you would give to people to stop hatred?","fwarefaefesd","fdsfdsafdsf"], category: "qualities"),
            CardModel(id: 4, question: "Going to the weekends upcoming Event?", choices: ["Yes", "Maybe", "No"], category: "qualities"),
            CardModel(id: 5, question: "What excites you the most in life?", choices: ["What is that one piece of advice you would give to people to stop hatred?","fwarefaefesd","fdsfdsafdsf"], category: "qualities"),
            CardModel(id: 6, question: "What is the first thing you do in the morning?", choices: ["What is that one piece of advice you would give to people to stop hatred?","fwarefaefesd","fdsfdsafdsf"], category: "event"),
            CardModel(id: 7, question: "When are you Free This Week?", choices: ["Sunday", "Monday"], category: "event"),
            CardModel(id: 8, question: "Time?", choices: ["MOrning", "AfterNoon"], category: "qualities"),
            CardModel(id: 9, question: "What do you want to do?", choices: ["BikeRiding", "RiverWalk"], category: "qualities"),
            CardModel(id: 10, question: "What is the first thing you do in the morning?", choices: ["What is that one piece of advice you would give to people to stop hatred?","fwarefaefesd","fdsfdsafdsf"], category: "qualities"),
            CardModel(id: 11, question: "What excites you the most in life?", choices: ["What is that one piece of advice you would give to people to stop hatred?","fwarefaefesd","fdsfdsafdsf"], category: "qualities"),
            
        ]
    }
    
    static var eventsSampleData: [EventModel] {
        [
            
            EventModel(id: 0, title: "SppeDDating KickBall", Date: "August 25th 2023", participants: ["Bob", "Ellen"]),
            EventModel(id: 0, title: "SppeDDating KickBall", Date: "August 25th 2023", participants: ["Bob", "Ellen"]),
            EventModel(id: 0, title: "SppeDDating KickBall", Date: "August 25th 2023", participants: ["Bob", "Ellen"])
        ]
    }
}
