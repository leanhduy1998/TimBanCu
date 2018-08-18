//
//  UserHelper.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CurrentUserHelper{
    private static var student:Student!
    
    static func hasEnoughDataInFireBase() -> Bool {
        if(student.isStudentInfoCompleted()){
            return true
        }
        return false
    }
    
    static func addEnrollment(classD: ClassProtocol){
        if let classDetail = classD as? ClassDetail{
            addEnrollment(classDetail: classDetail)
        }
    }
    
    private static func addEnrollment(classDetail:ClassDetail){
        if(student == nil || !student.isStudentInfoCompleted()){
            print("Does not have enough data to update!")
        }
        else{
            student.enrolledIn.append(classDetail)
            updateStudentEnrollmentToFirebase()
        }
    }
    
    static func getEnrolledClasses()-> [ClassDetail]{
        return student.enrolledIn
    }
    
    static func updateStudentEnrollmentToFirebase(){
        // do this because firebase can't save ClassDetail
        var enrollDics = [[String:String]]()
        
        for classDetail in student.enrolledIn{
            enrollDics.append(classDetail.convertToDictionary())
        }
        Database.database().reference().child("publicUserProfile").child(student.uid).child("enrolledIn").setValue(enrollDics)
    }

    
    static func setStudent(student:Student){
        self.student = student
    }
    static func getStudent() -> Student{
        return student
    }
    
    static func getUid() -> String{
        return student.uid
    }
    static func getFullname()->String{
        return student.fullName
    }
    
}
