//
//  Class.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ClassDetail{
    //class Detail: 10A11
    // class name: Lớp 10
    
    var className:String!
    var uid:String!
    var schoolName:String!
    var classNumber:String!
    var classYear = "Năm ?"
    
    init(classNumber:String,uid:String, schoolName:String, className:String,classYear:String){
        self.classNumber = classNumber
        self.uid = uid
        self.schoolName = schoolName
        self.className = className
        self.classYear = classYear
    }
    
    init(classNumber:String,uid:String, schoolName:String, className:String){
        self.classNumber = classNumber
        self.uid = uid
        self.schoolName = schoolName
        self.className = className
    }
    
    private func getObjectValueAsDic() -> [String:Any]{
        return ["uid":uid,"classNumber":classNumber,"classYear":classYear]
    }
    
    func writeClassDetailToDatabase(completionHandler: @escaping (_ err:Error?,_ ref:DatabaseReference) -> Void){
        let classesDetailRef = Database.database().reference().child("classes")
        classesDetailRef.child(schoolName).child(classNumber).child(className).child(classYear).setValue(getObjectValueAsDic(), withCompletionBlock: completionHandler)
    }
}
