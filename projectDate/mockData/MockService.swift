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
            userProfile: profileSampleData
        )
    }
    
    static var profileSampleData: ProfileModel {
        ProfileModel(
            id: "John",
            fullName: "Bon",
            location: "Tampa, Fl",
            gender: "Male"
//            image: "animeGirl"
        )
    }
    
    static var profileInfoSampleData: ProfileInfoModel {
        ProfileInfoModel(
        aboutMe: "fdsafdsf",
        interests: "fdsfsdfsd",
        height: "6"
        )
    }
    
    static var profilesSampleData: [ProfileModel] {
        [
            ProfileModel(
                id: "John",
                fullName: "Bon",
                location: "Tampa, Fl",
                gender: "Male"
//                image: "animeGirl"
            ),
            ProfileModel(
                id: "John",
                fullName: "Bon",
                location: "Tampa, Fl",
                gender: "Male"
//                image: "animeGirl"
            ),
            ProfileModel(
                id: "John",
                fullName: "Bon",
                location: "Tampa, Fl",
                gender: "Male"
//                image: "animeGirl"
            ),
            ProfileModel(
                id: "John",
                fullName: "Bon",
                location: "Tampa, Fl",
                gender: "Male"
//                image: "animeGirl"
            )
        ]
    }
    
    static var cardObjectSampleData: CardsModel {
        CardsModel(cards: cardsSampleData)
    }
    
    static var cardsSampleData: [CardModel] {
        [
            CardModel(
                id: "0",
                question: "what if someone wanted to sleep over? Are you a sleepOVer type of person blkah nted to sleep over? Are you a sleepOVer type of person blkah",
                choices: ["fadsfdsf", "fdasfsdfsd"],
                categoryType: "values",
                profileType: "Friend"
            ),
            CardModel(
                id: "1",
                question: "what if someone wanted to sleep over? Are you a sleepOVer type of person blkah nted to sleep over? Are you a sleepOVer type of person blkah",
                choices: ["fadsfdsf", "fdasfsdfsd"],
                categoryType: "value",
                profileType: "Friend"
            ),
            CardModel(
                id: "2",
                question: "what if someone wanted to sleep over? Are you a sleepOVer type of person blkah nted to sleep over? Are you a sleepOVer type of person blkah",
                choices: ["fadsfdsf", "fdasfsdfsd"],
                categoryType: "value",
                profileType: "Friend"
            ),
            CardModel(
                id: "3",
                question: "what if someone wanted to sleep over? Are you a sleepOVer type of person blkah nted to sleep over? Are you a sleepOVer type of person blkah",
                choices: ["fadsfdsf", "fdasfsdfsd"],
                categoryType: "value",
                profileType: "Friend"
            ),
//            CardModel(
//                id: "4",
//                question: "what if someone wanted to sleep over? Are you a sleepOVer type of person blkah nted to sleep over? Are you a sleepOVer type of person blkah",
//                choices: ["fadsfdsf", "fdasfsdfsd"],
//                category: "value",
//                profileType: "Friend"
//            ),
//            CardModel(
//                id: "5",
//                question: "what if someone wanted to sleep over? Are you a sleepOVer type of person blkah nted to sleep over? Are you a sleepOVer type of person blkah",
//                choices: ["fadsfdsf", "fdasfsdfsd"],
//                category: "value",
//                profileType: "Friend"
//            ),
//            CardModel(
//                id: "6",
//                question: "what if someone wanted to sleep over? Are you a sleepOVer type of person blkah nted to sleep over? Are you a sleepOVer type of person blkah",
//                choices: ["fadsfdsf", "fdasfsdfsd"],
//                category: "value",
//                profileType: "Friend"
//            ),
//            CardModel(
//                id: "7",
//                question: "what if someone wanted to sleep over? Are you a sleepOVer type of person blkah nted to sleep over? Are you a sleepOVer type of person blkah",
//                choices: ["fadsfdsf", "fdasfsdfsd"],
//                category: "value",
//                profileType: "Friend"
//            ),
//            CardModel(
//                id: "8",
//                question: "what if someone wanted to sleep over? Are you a sleepOVer type of person blkah nted to sleep over? Are you a sleepOVer type of person blkah",
//                choices: ["fadsfdsf", "fdasfsdfsd"],
//                category: "value",
//                profileType: "Friend"
//            ),
//            CardModel(
//                id: "9",
//                question: "what if someone wanted to sleep over? Are you a sleepOVer type of person blkah nted to sleep over? Are you a sleepOVer type of person blkah",
//                choices: ["fadsfdsf", "fdasfsdfsd"],
//                category: "value",
//                profileType: "Friend"
//            ),
//            CardModel(
//                id: "10",
//                question: "what if someone wanted to sleep over? Are you a sleepOVer type of person blkah nted to sleep over? Are you a sleepOVer type of person blkah",
//                choices: ["fadsfdsf", "fdasfsdfsd"],
//                category: "value",
//                profileType: "Friend"
//            )
            
        ]
    }
    
    static var eventsSampleData: [EventModel] {
        [
           EventModel(
            id: "0",
            title: "Event title 1",
            location: "Tampa, Fl",
            description: "fdsfdsfdsafsdfsd",
            participants: ["fadsfdsfds"],
            eventDate: Date()
           )
//           EventModel(
//            id: 1,
//            title: "Event title 1 Event title 1 Event title 1 Event title 1 ent title 1 Event title 1 Event title 1",
//            location: "Tampa, Fl",
//            creationDate: Date(),
//            description: "fdsfdsfdsafsdfsd nt title 1 Event title 1 Event title 1 Event title 1 ent title 1 Event title 1 Event title 1 nt title 1 Event title 1 Event title 1 Event title 1 ent title 1 Event title 1 Event title 1",
//            participants: profilesSampleData,
//            eventDate: Date()
//           ),
//           EventModel(
//            id: 2,
//            title: "Drew title 1",
//            location: "Tampa, Fl",
//            creationDate: Date(),
//            description: "fdsfdsfdsafsdfsd",
//            participants: profilesSampleData,
//            eventDate: Date()
//           ),
//           EventModel(
//            id: 3,
//            title: "Drew drew 1",
//            location: "Tampa, Fl",
//            creationDate: Date(),
//            description: "fdsfdsfdsafsdfsd",
//            participants: profilesSampleData,
//            eventDate: Date()
//           )
        ]
    }
    
//    static var sdSampleData: sdModel {
//        sdModel(
//            firstName: "Drew",
//            lastName: "Drew",
//            time: 4743843,
//            userRoleType: "host",
//            roomNumber: "638d9e07aee54625da64dfe2",
//            profiles: profilesSampleData
//        )
//    }
//    
//    static var sdsSampleData: [sdModel] {
//        [
//            sdModel(
//                firstName: "Drew",
//                lastName: "Drew",
//                time: 172805,
//                userRoleType: "host",
//                roomNumber: "638d9e07aee54625da64dfe2",
//                profiles: profilesSampleData
//            ),
//            sdModel(
//                firstName: "D",
//                lastName: "ew",
//                time: 384585,
//                userRoleType: "guest",
//                roomNumber: "638d9e07aee54625da64dfe2",
//                profiles: profilesSampleData
//            ),
//            sdModel(
//                firstName: "w",
//                lastName: "w",
//                time: 5059448,
//                userRoleType: "host",
//                roomNumber: "638d9e07aee54625da64dfe2",
//                profiles: profilesSampleData
//            ),
//            sdModel(
//                firstName: "D",
//                lastName: "ew",
//                time: 384585,
//                userRoleType: "guest",
//                roomNumber: "638d9e07aee54625da64dfe2",
//                profiles: profilesSampleData
//            ),
//            sdModel(
//                firstName: "D",
//                lastName: "ew",
//                time: 384585,
//                userRoleType: "guest",
//                roomNumber: "638d9e07aee54625da64dfe2",
//                profiles: profilesSampleData
//            ),
//            sdModel(
//                firstName: "D",
//                lastName: "ew",
//                time: 384585,
//                userRoleType: "guest",
//                roomNumber: "638d9e07aee54625da64dfe2",
//                profiles: profilesSampleData
//            )
//        ]
//    }
}
