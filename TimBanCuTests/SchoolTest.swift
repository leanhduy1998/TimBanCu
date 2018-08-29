//
//  ClassDetailTest.swift
//  TimBanCuTests
//
//  Created by Duy Le 2 on 8/19/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import XCTest
import FirebaseDatabase
@testable import TimBanCu

class SchoolTest: XCTestCase {
    
    var vc:SchoolViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vc = SchoolViewController()
        vc.setupAlerts()
        vc.setupSchoolFirebaseReferences()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmoticonFileName(){
        XCTAssertEqual(vc.emojiName, "empty_list", "Wrong Emoji File Name")
    }
    
    func testSchoolAlreadyExistAlert(){
        XCTAssertEqual(vc.schoolAlreadyExistAlert.title, "Trường của bạn đã có trong danh sách!", "Wrong Alert Title")
        XCTAssertEqual(vc.schoolAlreadyExistAlert.message, "Vui Lòng Chọn Trường Trong Danh Sách Chúng Tôi Hoặc Thêm Trường Mới", "Wrong Alert Message")
    }
    
}
