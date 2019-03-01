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
    static var student:Student!
    private static let ref = Database.database().reference()
    
    static func hasEnoughDataInFireBase() -> Bool {
        return student.isStudentInfoCompleted()
    }
    
    static func addEnrollmentLocalAndOnline(classProtocol: ClassAndMajorWithYearProtocol,completionHandler: @escaping (_ uiState:UIState) -> Void){
        if(student == nil || !student.isStudentInfoCompleted()){
            print("Does not have enough data to update!")
            completionHandler(.Failure("Chúng tôi không có đủ thông tin của bạn! Mong bạn vui lòng liên hệ andrewledev@gmail.com"))
        }
        else{
            student.enrolledIn.append(classProtocol)
            FirebaseUploader.shared.enroll(student: student, model: classProtocol, completionHandler: completionHandler)
        }
        
    }

    
    static func getEnrolledClasses()-> [ClassAndMajorWithYearProtocol]{
        if(student == nil){
            return []
        }
        else{
            return student!.enrolledIn
        }
    }
        
    static func getUid() -> String{
        return student.uid
    }
    static func getFullname()->String{
        return student.fullName
    }
    
}
