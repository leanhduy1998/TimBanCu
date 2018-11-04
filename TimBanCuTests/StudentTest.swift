//
//  StudentTest.swift
//  TimBanCuTests
//
//  Created by Duy Le 2 on 11/4/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import XCTest
@testable import TimBanCu

class StudentTest: XCTestCase {
    
    var student:Student!

    override func setUp() {
        student = Student(fullname: "fullname", birthYear: "birthYear", phoneNumber: "phoneNumber", email: "email", uid: "uid")
    }

    override func tearDown() {
        student = nil
    }
    
    func testFirebaseStorageFirstImagePath(){
        student.images = [Image(year: nil, imageName: "imageName", uid: "uid")]
        let path = student.firebaseStorageFirstImagePath()
        XCTAssertTrue(path == "users/uid/imageName")
    }
    
    func testIsStudentInfoCompleted(){
        XCTAssertTrue(student.isStudentInfoCompleted())
        student = Student(fullname: "fullname", birthYear: "", phoneNumber: "phoneNumber", email: "email", uid: "uid")
        XCTAssertFalse(student.isStudentInfoCompleted())
        student = Student(fullname: "", birthYear: "asd", phoneNumber: "phoneNumber", email: "email", uid: "uid")
        XCTAssertFalse(student.isStudentInfoCompleted())
        student = Student(fullname: "asd", birthYear: "asd", phoneNumber: "", email: "email", uid: "uid")
        XCTAssertFalse(student.isStudentInfoCompleted())
        student = Student(fullname: "asd", birthYear: "asd", phoneNumber: "asd", email: "", uid: "uid")
        XCTAssertFalse(student.isStudentInfoCompleted())
        student = Student(fullname: "asd", birthYear: "asd", phoneNumber: "asd", email: "asd", uid: "")
    }

    

}
