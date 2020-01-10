//
//  FirstTimeLaunch.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/20/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation

class FirstTimeLaunch{
    static func setTrue(){
        UserDefaults.standard.set(true, forKey: "firstTimeLaunch")
    }
    static func setFalse(){
        UserDefaults.standard.set(false, forKey: "firstTimeLaunch")
    }
    
    static func getBool() -> Bool{
        return UserDefaults.standard.bool(forKey: "firstTimeLaunch")
    }
}
