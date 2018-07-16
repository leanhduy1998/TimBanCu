//
//  Class.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation

class ClassDetail{
    var className:String!
    var uid:String!
    var schoolName:String!
    
    init(className:String,uid:String, schoolName:String){
        self.className = className
        self.uid = uid
        self.schoolName = schoolName
    }
    
    func getObjectValueAsDic() -> [String:Any]{
        return ["uid":uid]
    }
}
