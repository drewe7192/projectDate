//
//  projectDateTests.swift
//  projectDateTests
//
//  Created by Drew Sutherlan on 8/2/22.
//

import XCTest
@testable import projectDate

class projectDateTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    
    
    
    
    
    func test_getStorageFile_wrongProfileId_returnsError() throws {
     let sut = liveViewModel()
        
     let actual = sut.getStorageFile(profileId: "fkjfu6fkuycfkuycv")
        print("actual")
        print(actual)
        XCTAssertThrowsError(actual)
    }

    
    
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
