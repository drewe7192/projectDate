//
//  MockService.swift
//  projectDate
//
//  Created by DotZ3R0 on 12/29/22.
//

import Foundation

enum MockService {
    static var sampleData: [Profile] {
        [
            Profile(firstName: "Travon",
                    lastName: "Dayvon", location: "ClearWater, Fl"),
            Profile(firstName: "von",
                    lastName: "Day", location: "Tampa, Fl"),
            Profile(firstName: "22Gz",
                    lastName: "Blixy", location: "St.Pete, Fl"),
            Profile(firstName: "Felippe",
                    lastName: "Ferriera", location: "Tally, Fl"),
            Profile(firstName: "Sierra",
                    lastName: "AppleWhite", location: "ClearWater, Fl"),
            Profile(firstName: "Ashley",
                    lastName: "Bashely", location: "ClearWater, Fl"),
            Profile(firstName: "My",
                    lastName: "Dude", location: "ClearWater, Fl"),
            Profile(firstName: "Travon",
                    lastName: "Dayvon", location: "ClearWater, Fl"),
            Profile(firstName: "Travon",
                    lastName: "Dayvon", location: "ClearWater, Fl"),
            
        ]
    }
    
    static var userSampleData: User {
        User(firstName: "Travon",
             lastName: "Dayvon", location: "ClearWater, Fl",
             sdTimes:  [
                sdTimeModel(
                    firstName: "Drew",
                    lastName: "Drew",
                    time: Date.now,
                    userRoleType: "host"
                ),
                sdTimeModel(
                    firstName: "D",
                    lastName: "ew",
                    time: Date.now,
                    userRoleType: "guest"
                ),
                sdTimeModel(
                    firstName: "w",
                    lastName: "w",
                    time: Date.now,
                    userRoleType: "host"
                )
             ]
        )
    }
}
