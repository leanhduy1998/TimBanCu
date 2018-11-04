//
//  MajorWithYearTest.swift
//  TimBanCuTests
//
//  Created by Duy Le 2 on 11/4/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import XCTest
@testable import TimBanCu

class MajorWithYearTest: XCTestCase {
    
    var major:MajorWithYear!

    override func setUp() {
        major = MajorWithYear(major: Major(institution: Institution(name: "institutionName"), uid: "uid", majorName: "majorName"), year: "year")
    }

    override func tearDown() {
        major = nil
    }
    
    func testObjectAsDictionary(){
        let dic = major.objectAsDictionary()
        XCTAssertTrue(dic.keys.first == major.institution.name)
        
        let subDic = dic[dic.keys.first!]
        XCTAssertTrue(subDic!["majorName"] == "majorName")
        XCTAssertTrue(subDic!["uid"] == "uid")
        XCTAssertTrue(subDic!["year"] == "year")
    }
    
    func testFirebaseClassYearPath(){
        let path = major.firebaseClassYearPath(withParent: "parent")
        XCTAssertFalse(StringTest.containOptional(string: path))
        XCTAssertTrue(path == "parent/institutionName/majorName/year")
    }

    

}
