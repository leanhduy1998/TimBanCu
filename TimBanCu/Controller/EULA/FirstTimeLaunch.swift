//
//  FirstTimeLaunch.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/20/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation

class FirstTimeLaunch{
    static var sharedInstance = FirstTimeLaunch()
    
    private var launched = false
    
    func setTrue(){
        FirstTimeLaunch.sharedInstance.launched = true
    }
    func setFalse(){
        FirstTimeLaunch.sharedInstance.launched = false
    }
    
    func getBool() -> Bool{
        return FirstTimeLaunch.sharedInstance.launched
    }
}
