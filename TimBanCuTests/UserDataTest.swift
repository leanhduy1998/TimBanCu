//
//  UserDataTest.swift
//  TimBanCuTests
//
//  Created by Duy Le 2 on 11/4/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import XCTest
@testable import TimBanCu

class UserDataTest: XCTestCase {
    
    var userData:UserData!

    override func setUp() {
        userData = UserData(student: Student(fullname: "fullname", birthYear: "birthYear", phoneNumber: "phoneNumber", email: "email", uid: "uid"), phonePrivacyType: "phonePrivacyType", emailPrivacyType: "emailPrivacyType", images: [Image(year: "year", imageName: "imageName", uid: "uid")])
    }

    override func tearDown() {
        userData = nil
    }

    func testFirebasePublicUploadDataPath(){
        let path = userData.firebasePublicUploadDataPath()
        XCTAssertTrue(path == "publicUserProfile/uid")
    }
    
    func testFirebasePrivateUploadDataPath(){
        let path = userData.firebasePrivateUploadDataPath()
        XCTAssertTrue(path == "privateUserProfile/uid")
    }
    
    func testFirebaseStorageImageUploadPath(){
        CurrentUser.student = Student(fullname: "fullname", birthYear: "birthYear", phoneNumber: "phoneNumber", email: "email", uid: "uid")
        
        let path = userData.firebaseStorageImageUploadPath(name: "name")
        XCTAssertTrue(path == "users/uid/name")
        
        CurrentUser.student = nil
    }

}
