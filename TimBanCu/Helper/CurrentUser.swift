//
//  UserHelper.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CurrentUser{
    private static var student:Student!
    private static let ref = Database.database().reference()
    
    static func hasEnoughDataInFireBase() -> Bool {
        if(student.isStudentInfoCompleted()){
            return true
        }
        return false
    }
    
    static func addEnrollment(classProtocol: ClassProtocol,completionHandler: @escaping (_ uiState:UIState) -> Void){
        if(student == nil || !student.isStudentInfoCompleted()){
            print("Does not have enough data to update!")
        }
        else{
            student.enrolledIn.append(classProtocol)
            updateStudentEnrollmentToFirebase(classProtocol: classProtocol, completionHandler: completionHandler)
        }
    }

    
    static func getEnrolledClasses()-> [ClassProtocol]{
        if(student == nil){
            return []
        }
        else{
            return student.enrolledIn
        }
    }
    
    private static func updateStudentEnrollmentToFirebase(classProtocol: ClassProtocol,completionHandler: @escaping (_ uiState:UIState) -> Void){
        // do this because firebase can't save ClassDetail
        var enrollDics = [[String:String]]()
        
        for classProtocol in student.enrolledIn{
            enrollDics.append(classProtocol.getModelAsDictionary() as! [String : String])
        }
        
        var finishUpdatePublicUserProfile = false
        var finishUpdateStudentList = false
        
        ref.child("publicUserProfile/\(student.uid!)/enrolledIn").setValue(enrollDics) { (error, _) in
            
            if(error == nil){
                finishUpdatePublicUserProfile = true
                if(finishUpdateStudentList){
                    completionHandler(.Success())
                }
            }
            else{
                completionHandler(.Failure((error?.localizedDescription)!))
            }
        }
        
        ref.child("students/\(classProtocol.getFirebasePathWithSchoolYear())/\(CurrentUser.getUid())").setValue(CurrentUser.getFullname()) { (error, ref) in
            if(error == nil){
                finishUpdateStudentList = true
                if(finishUpdatePublicUserProfile){
                    completionHandler(.Success())
                }
            }
            else{
                completionHandler(.Failure((error?.localizedDescription)!))
            }
        }
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
