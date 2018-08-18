//
//  Class.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ClassDetail: ClassProtocol{
    //class Detail: 10A11
    // class name: Lớp 10
    
    var className:String!
    var uid:String!
    var schoolName:String!
    var classNumber:String!
    var classYear = "Năm ?"
    
    init(classDic:[String:String]){
        className = classDic["className"]
        uid = classDic["uid"]
        schoolName = classDic["schoolName"]
        classNumber = classDic["classNumber"]
        classYear = classDic["classYear"]!
    }
    
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
    
    func convertToDictionary() -> [String:String]{
        var dic = [String:String]()
        dic["className"] = className
        dic["uid"] = uid
        dic["schoolName"] = schoolName
        dic["classNumber"] = classNumber
        dic["classYear"] = classYear
        
        return dic
    }
    
    private func getObjectValueAsDic() -> [String:Any]{
        return ["uid":uid,"classNumber":classNumber]
    }
    
    func getFirebasePathWithoutSchoolYear()->String{
        return "\(schoolName!)/\(classNumber!)/\(className!)"
    }
    
    func getFirebasePathWithSchoolYear()->String{
        return "\(schoolName!)/\(classNumber!)/\(className!)/\(classYear)"
    }
    
    func writeToDatabase(completionHandler: @escaping (_ err:Error?,_ ref:DatabaseReference) -> Void){
        let classesDetailRef = Database.database().reference().child("classes")
        classesDetailRef.child(getFirebasePathWithSchoolYear()).setValue(getObjectValueAsDic(), withCompletionBlock: completionHandler)
    }
}
