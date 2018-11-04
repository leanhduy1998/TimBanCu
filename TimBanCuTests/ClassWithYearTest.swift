//
//  ClassWithYearTest.swift
//  TimBanCuTests
//
//  Created by Duy Le 2 on 10/31/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import XCTest
@testable import TimBanCu
class ClassWithYearTest: XCTestCase {
    
    var firstInit:ClassWithYear!
    var secondInit:ClassWithYear!

    override func setUp() {
        firstInit = ClassWithYear(classs: Class(institution: Institution(name: "name"), classNumber: "classNumber", className: "className", uid: "uid"), year: "year")
    }

    override func tearDown() {
        firstInit = nil
    }

    func testInit() {
        
        XCTAssertTrue(firstInit.year == "year")
        // other cases are tested by Class class
        
        secondInit = ClassWithYear(classWithYear: firstInit)
        XCTAssertTrue(secondInit.year == "year")
    }
    
    func testFirebaseClassYearPath(){
        let path = firstInit.firebaseClassYearPath(year: "1999")
        XCTAssertFalse(StringTest.containOptional(string: path))
        XCTAssertTrue(path == "classes/name/classNumber/className/1999")
    }
    
    func testObjectAsDictionary(){
        let dic = firstInit.objectAsDictionary()
        XCTAssertTrue(dic.keys.first == firstInit.institution.name)
        XCTAssertTrue(dic[dic.keys.first!]!["className"] == firstInit.getClassName())
        XCTAssertTrue(dic[dic.keys.first!]!["classNumber"] == firstInit.getClassNumber())
        XCTAssertTrue(dic[dic.keys.first!]!["uid"] == firstInit.uid)
        XCTAssertTrue(dic[dic.keys.first!]!["year"] == firstInit.year)
    }



}
