//
//  Class.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation

class ClassDetail{
    //class Detail: 10A11
    // class name: Lớp 10
    
    var className:String!
    var uid:String!
    var schoolName:String!
    var classNumber:String!
    
    init(classNumber:String,uid:String, schoolName:String, className:String){
        self.classNumber = classNumber
        self.uid = uid
        self.schoolName = schoolName
        self.className = className
    }
    
    func getObjectKey()->String{
        return "\(schoolName!) && \(className!)"
    }
    
    func getObjectValueAsDic() -> [String:Any]{
        return ["uid":uid,"classNumber":classNumber,"schoolName":schoolName,"className":className]
    }
}
