//
//  MajorTest.swift
//  TimBanCuTests
//
//  Created by Duy Le 2 on 11/3/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import XCTest
@testable import TimBanCu

class MajorTest: XCTestCase {
    
    var major:Major!
    
    override func setUp() {
        major = Major(institution: Institution(name: "institutionName"), uid: "uid", majorName: "majorName")
    }

    override func tearDown() {
        major = nil
    }

    func testFirebaseClassYearPath(){
        let path = major.firebaseClassYearPath(year: "1990")
        XCTAssertFalse(StringTest.containOptional(string: path))
        XCTAssertTrue(path == "classes/institutionName/majorName/1990")
    }
    
    func testFirebaseCreatedByPath(){
        let path = major.firebaseCreatedByPath()
        XCTAssertFalse(StringTest.containOptional(string: path))
        XCTAssertTrue(path == "classes/institutionName/majorName/createdBy")
    }
    
    func testFirebaseFetchPath(){
        let institution = InstitutionFull(name: "name", type: "type", addByUid: "uid")
        let path = Major.firebaseFetchPath(institution: institution)
        XCTAssertFalse(StringTest.containOptional(string: path))
        XCTAssertTrue(path == "classes/name")
    }

}
