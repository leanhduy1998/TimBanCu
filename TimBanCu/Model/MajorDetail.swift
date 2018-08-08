//
//  MajorDetail.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/2/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

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
        self.majorYear = "Năm ?"
    }
    
    private func getObjectValueAsDic() -> [String:Any]{
        return ["uid":uid,"majorName":majorName]
    }
    
    func writeMajorDetailToDatabase(completionHandler: @escaping (_ err:Error?,_ ref:DatabaseReference) -> Void){
        
        Database.database().reference().child("classes").child(schoolName).child(majorYear).setValue(getObjectValueAsDic(), withCompletionBlock: completionHandler)
    }
}

