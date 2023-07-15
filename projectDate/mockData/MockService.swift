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
        ProfileModel(
            id: "John",
            fullName: "Bon",
            location: "Tampa, Fl",
            gender: "Male",
            messageThreadIds: [],
            speedDateIds: [],
            fcmTokens: [],
            preferredGender: "",
            currentRoomId: ""
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
                id: "1C104E11-D984-4435-A41D-39968BD39062",
                fullName: "Bon",
                location: "Tampa, Fl",
                gender: "Male",
                messageThreadIds: [],
                speedDateIds: [],
                fcmTokens: [],
                preferredGender: "",
                currentRoomId: ""
            ),
            ProfileModel(
                id: "4D2210FA-D5D8-48C2-8FBB-F81593987EE1",
                fullName: "Bon",
                location: "Tampa, Fl",
                gender: "Male",
                messageThreadIds: [],
                speedDateIds: [],
                fcmTokens: [],
                preferredGender: "",
                currentRoomId: ""
            ),
            ProfileModel(
                id: "B2F39E11-0241-499B-AC79-DD639C5E15EF",
                fullName: "Bon",
                location: "Tampa, Fl",
                gender: "Male",
                messageThreadIds: [],
                speedDateIds: [],
                fcmTokens: [],
                preferredGender: "",
                currentRoomId: ""
            ),
            ProfileModel(
                id: "EF7C8A72-87C1-4FD5-ABFE-D458C0D86E90",
                fullName: "Bon",
                location: "Tampa, Fl",
                gender: "Male",
                messageThreadIds: [],
                speedDateIds: [],
                fcmTokens: [],
                preferredGender: "",
                currentRoomId: ""
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
                categoryType: "littleThings",
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
    
    static var sdSampleData: SpeedDateModel {
        SpeedDateModel(
            id: "",
            maleRoomCode: "",
            femaleRoomCode: "",
            roomId: "",
            matchProfileIds: [],
            eventDate: Date(),
            createdDate: Date(),
            isActive: false
        )
    }
    
    static var sdsSampleData: [SpeedDateModel] {
        [
            SpeedDateModel(
                id: "",
                maleRoomCode: "",
                femaleRoomCode: "",
                roomId: "",
                matchProfileIds: [],
                eventDate: Date(),
                createdDate: Date(),
                isActive: false
            ),
            SpeedDateModel(
                id: "",
                maleRoomCode: "",
                femaleRoomCode: "",
                roomId: "",
                matchProfileIds: [],
                eventDate: Date(),
                createdDate: Date(),
                isActive: false
            ),
            SpeedDateModel(
                id: "",
                maleRoomCode: "",
                femaleRoomCode: "",
                roomId: "",
                matchProfileIds: [],
                eventDate: Date(),
                createdDate: Date(),
                isActive: false
            ),
            SpeedDateModel(
                id: "",
                maleRoomCode: "",
                femaleRoomCode: "",
                roomId: "",
                matchProfileIds: [],
                eventDate: Date(),
                createdDate: Date(),
                isActive: false
            ),
            SpeedDateModel(
                id: "",
                maleRoomCode: "",
                femaleRoomCode: "",
                roomId: "",
                matchProfileIds: [],
                eventDate: Date(),
                createdDate: Date(),
                isActive: false
            ),
            SpeedDateModel(
                id: "",
                maleRoomCode: "",
                femaleRoomCode: "",
                roomId: "",
                matchProfileIds: [],
                eventDate: Date(),
                createdDate: Date(),
                isActive: false
            )
        ]
    }
}
