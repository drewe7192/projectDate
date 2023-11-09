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
//            ProfileModel(
//                id: "1C104E11-D984-4435-A41D-39968BD39062",
//                fullName: "Ashely",
//                location: "Tampa, Fl",
//                gender: "Male",
//                messageThreadIds: [],
//                speedDateIds: [],
//                fcmTokens: [],
//                preferredGender: "",
//                currentRoomId: ""
//            ),
//            ProfileModel(
//                id: "4D2210FA-D5D8-48C2-8FBB-F81593987EE1",
//                fullName: "Brittney",
//                location: "Tampa, Fl",
//                gender: "Male",
//                messageThreadIds: [],
//                speedDateIds: [],
//                fcmTokens: [],
//                preferredGender: "",
//                currentRoomId: ""
//            ),
//            ProfileModel(
//                id: "B2F39E11-0241-499B-AC79-DD639C5E15EF",
//                fullName: "Jenny",
//                location: "Tampa, Fl",
//                gender: "Male",
//                messageThreadIds: [],
//                speedDateIds: [],
//                fcmTokens: [],
//                preferredGender: "",
//                currentRoomId: ""
//            ),
//            ProfileModel(
//                id: "EF7C8A72-87C1-4FD5-ABFE-D458C0D86E90",
//                fullName: "Lauren",
//                location: "Tampa, Fl",
//                gender: "Male",
//                messageThreadIds: [],
//                speedDateIds: [],
//                fcmTokens: [],
//                preferredGender: "",
//                currentRoomId: ""
//            )
            ProfileModel(
                id: "yz6aIZxyWjiUlnjePSwr",
                fullName: "Parker",
                location: "Tampa, Fl",
                gender: "Male",
                messageThreadIds: [],
                speedDateIds: [],
                fcmTokens: [],
                preferredGender: "",
                currentRoomId: ""
            ),
            ProfileModel(
                id: "rhQ1dvqXVlrheXcIAv60",
                fullName: "River",
                location: "Tampa, Fl",
                gender: "Male",
                messageThreadIds: [],
                speedDateIds: [],
                fcmTokens: [],
                preferredGender: "",
                currentRoomId: ""
            ),
            ProfileModel(
                id: "pzjLV9vxyuxSb93dFCV0",
                fullName: "Jordan",
                location: "Tampa, Fl",
                gender: "Male",
                messageThreadIds: [],
                speedDateIds: [],
                fcmTokens: [],
                preferredGender: "",
                currentRoomId: ""
            ),
            ProfileModel(
                id: "8X6IW1hE6iMwSoaB7WbH",
                fullName: "Hunter",
                location: "Tampa, Fl",
                gender: "Male",
                messageThreadIds: [],
                speedDateIds: [],
                fcmTokens: [],
                preferredGender: "",
                currentRoomId: ""
            ),
            ProfileModel(
                id: "JGZ3nFeUwLgQqv4fwyVI",
                fullName: "Riley",
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
