//
//  InstitutionFullTest.swift
//  TimBanCuTests
//
//  Created by Duy Le 2 on 10/26/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import XCTest
@testable import TimBanCu

class InstitutionFullTest: XCTestCase {
    var institution:InstitutionFull!
    
    override func setUp() {
        super.setUp()
        institution = InstitutionFull(name: "testName", address: "testAddress", type: "testType", addByUid: "testId")
    }
    
    func testGetInstitutions(){
        let institution = InstitutionFull.getInstitution(key: "testname", value: ["address":"testAddress","uid":"testUid"], educationLevel: EducationLevel.Elementary)
        XCTAssertTrue(institution.address == "testAddress")
        XCTAssertTrue(institution.name == "testname")
        XCTAssertTrue(institution.addByUid == "testUid")
    }
    
    func testInit(){
        let firstInit = InstitutionFull(name: "testName", address: "testAddress", type: "testType", addByUid: "testId")
        XCTAssertTrue(firstInit.address == "testAddress")
        XCTAssertTrue(firstInit.name == "testName")
        XCTAssertTrue(firstInit.addByUid == "testId")
        XCTAssertTrue(firstInit.type == "testType")
        
        let secondInit = InstitutionFull(name: "testName", type: "testType", addByUid: "testId")
        XCTAssertTrue(secondInit.address == nil)
        XCTAssertTrue(secondInit.name == "testName")
        XCTAssertTrue(secondInit.addByUid == "testId")
        XCTAssertTrue(secondInit.type == "testType")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    

}
