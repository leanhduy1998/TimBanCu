//
//  Class.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ClassWithYear: Class, ClassAndMajorWithYearProtocol{

    var year: String
    
    init(classs:Class,year:String){
        self.year = year
        super.init(classs: classs)
    }
    
    init(classWithYear:ClassWithYear){
        self.year = classWithYear.year
        super.init(institution: classWithYear.institution, classNumber: classWithYear.classNumber, className: classWithYear.className, uid: classWithYear.uid)
        
    }
    
    func addToPublicStudentListOnFirebase(student:Student,completionHandler: @escaping (_ uiState:UIState) -> Void) {
        Database.database().reference().child("students/\(institution.name!)/\(classNumber)/\(className)/\(year)").child(student.uid).setValue(student.fullName) { (err, _) in
            if(err == nil){
                completionHandler(.Success())
            }
            else{
                completionHandler(.Failure((err?.localizedDescription)!))
            }
        }
    }
    
    func getInstitution() -> Institution {
        return super.institution
    }
    
    func getFirebasePath() -> String {
        return "\(institution.name!)/\(classNumber)/\(className)/\(year)"
    }
    
    func objectAsDictionary() -> [String : [String:String]] {
        var dic = [String:[String:String]]()
        dic[institution.name!] = ["className":className,"uid":uid,"classNumber":classNumber,"year":year]
        return dic
    }

    func copy() -> ClassAndMajorWithYearProtocol {
        return ClassWithYear(classWithYear: self)
    }
    
    /*
    
    init(classNumber:String,uid:String, schoolName:String, className:String,classYear:String){
        self.classNumber = classNumber
        self.uid = uid
        self.schoolName = schoolName
        self.className = className
        self.year = classYear
    }
    
    init(classNumber:String,uid:String, schoolName:String, className:String){
        self.classNumber = classNumber
        self.uid = uid
        self.schoolName = schoolName
        self.className = className
    }
    
    func getModelAsDictionary() -> [String:Any]{
        var dic = [String:String]()
        dic["className"] = className
        dic["uid"] = uid
        dic["schoolName"] = schoolName
        dic["classNumber"] = classNumber
        dic["classYear"] = year
        
        return dic
    }*/
        
    
    func uploadToFirebase(year:String,completionHandler: @escaping (UIState) -> Void) {
        Database.database().reference().child("classes/\(institution.name!)/\(classNumber)/\(className)/\(year)").setValue(CurrentUser.getUid()) { (err, _) in
            if(err == nil){
                completionHandler(.Success())
            }
            else{
                completionHandler(.Failure(err.debugDescription))
            }
        }
    }
    
    override func uploadToFirebase(completionHandler: @escaping (UIState) -> Void) {
        fatalError("Not Supported")
    }
}
