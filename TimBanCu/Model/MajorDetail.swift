//
//  MajorDetail.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/2/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MajorDetail: ClassProtocol{
    //class Detail: 10A11
    // class name: Lớp 10
    
    var uid:String!
    var schoolName:String!
    var majorName:String!
    var year:String!
    
    init(uid:String, schoolName:String, majorName:String,majorYear:String){
        self.uid = uid
        self.schoolName = schoolName
        self.majorName = majorName
        self.year = majorYear
    }
    
    init(uid:String, schoolName:String, majorName:String){
        self.uid = uid
        self.schoolName = schoolName
        self.majorName = majorName
        self.year = "Năm ?"
    }
    
    private func getObjectValueAsDic() -> [String:Any]{
        return ["uid":uid]
    }
    
    func getFirebasePathWithoutSchoolYear() -> String {
        return "\(schoolName!)/\(majorName!)"
    }
    
    func getFirebasePathWithSchoolYear() -> String {
        return "\(schoolName!)/\(majorName!)/\(year!)"
    }
    
    
    func writeToDatabase(completionHandler: @escaping (_ err:Error?,_ ref:DatabaseReference) -> Void){
        Database.database().reference().child("classes").child(getFirebasePathWithSchoolYear()).setValue(getObjectValueAsDic(), withCompletionBlock: completionHandler)
    }
}

