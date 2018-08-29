//
//  ClassYearTest.swift
//  TimBanCuTests
//
//  Created by Duy Le 2 on 8/19/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import XCTest
@testable import TimBanCu

class ClassYearTest: XCTestCase {
    
    var vc:ClassYearViewController!
    
    override func setUp() {
        super.setUp()
        vc = ClassYearViewController()
        vc.setupManualYears()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testYearsArray(){
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        let aHundredYearsAgo = year - 80
        
        //if now is 2018, the allowed year is 1918, and anything before that is not allowed
        let notAllowedYear = aHundredYearsAgo - 1
        
        XCTAssertFalse(vc.years.contains("Năm \(notAllowedYear)"))
    }
    
}
