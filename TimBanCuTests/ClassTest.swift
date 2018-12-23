//
//  ClassTest.swift
//  TimBanCuTests
//
//  Created by Duy Le 2 on 10/30/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import XCTest
@testable import TimBanCu

class ClassTest: XCTestCase {
    
    var firstInit:Class!
    var secondInit:Class!
    var thirdInit:Class!
    var institution:Institution! = Institution(name: "name")
    var institutionFull:InstitutionFull! = InstitutionFull(name: "name", address: "address", type: "type", addByUid: "uid")
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        firstInit = nil
        secondInit = nil
        thirdInit = nil
        institution = nil
        institutionFull = nil
    }

    func testInit(){
        firstInit = Class(institution: institution, classNumber: "classNumber", className: "className", uid: "uid")
        XCTAssertTrue(firstInit.institution != nil)
        XCTAssertTrue(firstInit.getClassNumber() == "classNumber")
        XCTAssertTrue(firstInit.getClassName() == "className")
        XCTAssertTrue(firstInit.uid == "uid")
        XCTAssertFalse(StringTest.containOptional(string: firstInit.firebaseUploadPath()))
        
        secondInit = Class(classs: firstInit)
        XCTAssertTrue(secondInit.institution != nil)
        XCTAssertTrue(secondInit.getClassNumber() == "classNumber")
        XCTAssertTrue(secondInit.getClassName() == "className")
        XCTAssertTrue(secondInit.uid == "uid")
        XCTAssertFalse(StringTest.containOptional(string: secondInit.firebaseUploadPath()))
        
        thirdInit = Class(institution: institutionFull, classNumber: "classNumber", className: "className", uid: "uid")
        XCTAssertTrue(thirdInit.institution != nil)
        XCTAssertTrue(thirdInit.getClassNumber() == "classNumber")
        XCTAssertTrue(thirdInit.getClassName() == "className")
        XCTAssertTrue(thirdInit.uid == "uid")
        XCTAssertFalse(StringTest.containOptional(string: thirdInit.firebaseUploadPath()))
        
        XCTAssertTrue(firstInit.firebaseUploadPath() == "classes/name/classNumber/className/createdBy")
        XCTAssertTrue(secondInit.firebaseUploadPath() == "classes/name/classNumber/className/createdBy")
        XCTAssertTrue(thirdInit.firebaseUploadPath() == "classes/name/classNumber/className/createdBy")
        
    }
    
    func testNameExist(){
        firstInit = Class(institution: institution, classNumber: "classNumber", className: "className", uid: "uid")
        XCTAssertTrue(Class.nameExist(name: "className", classes: [firstInit]))
        XCTAssertFalse(Class.nameExist(name: "classNameFalse", classes: [firstInit]))
    }
    
    func testFirebaseClassYearPath(){
        firstInit = Class(institution: institution, classNumber: "classNumber", className: "className", uid: "uid")
        
        let path = firstInit.firebaseClassYearPath(year: "1990")
        
        XCTAssertFalse(StringTest.containOptional(string: path))
        XCTAssertTrue(path == "classes/name/classNumber/className/1990")
    }
    
    func testFirebaseFetchPath(){
        let path = Class.firebaseFetchPath(institutionName: "name", classNumber: "classNumber")

        XCTAssertFalse(StringTest.containOptional(string:  path))
        XCTAssertTrue(path == "classes/name/classNumber")
    }

}
