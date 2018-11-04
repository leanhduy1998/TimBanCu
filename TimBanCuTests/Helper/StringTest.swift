//
//  StringTest.swift
//  TimBanCuTests
//
//  Created by Duy Le 2 on 10/29/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation

class StringTest{
    static func containOptional(string:String)->Bool{
        if(string.contains("Optional")){
            return true
        }
        return false
    }
}
