//
//  MajorDetail.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/2/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation

class MajorDetail{
    //class Detail: 10A11
    // class name: Lớp 10
    
    var uid:String!
    var schoolName:String!
    var majorName:String
    var majorYear:String!
    
    init(uid:String, schoolName:String, majorName:String,majorYear:String){
        self.uid = uid
        self.schoolName = schoolName
        self.majorName = majorName
        self.majorYear = majorYear
    }
    
    init(uid:String, schoolName:String, majorName:String){
        self.uid = uid
        self.schoolName = schoolName
        self.majorName = majorName
    }
    
    func getObjectKey()->String{
        return "\(schoolName!) && \(majorName)"
    }
    
    func getObjectValueAsDic() -> [String:Any]{
        return ["uid":uid,"schoolName":schoolName,"majorName":majorName,"majorYear":majorYear]
    }
}

