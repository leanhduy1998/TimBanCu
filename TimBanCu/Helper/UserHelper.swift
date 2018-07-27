//
//  UserHelper.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserHelper{
    static var uid:String!
    static var student:Student!
    
    static func getStudentFromDatabase(uid:String,completionHandler: @escaping (_ student:Student) -> Void){
        let student = Student()
        student.uid = uid
        Database.database().reference().child("publicUserProfile").child(uid).observeSingleEvent(of: .value, with: { (publicSS) in
            
            if(!publicSS.hasChildren()){
                completionHandler(Student())
            }
            
            
            for snap in publicSS.children{
                let key = (snap as! DataSnapshot).key as! String
                
                if(key == "birthYear"){
                    let birthYear = (snap as! DataSnapshot).value as! String
                    student.birthYear = birthYear
                }
                else if(key == "images"){
                    let images = (snap as! DataSnapshot).value as! [String]
                    
                    student.imageUrls = images
                }
                else if(key == "phoneNumber"){
                    let phoneNumber = (snap as! DataSnapshot).value as! String
                    student.phoneNumber = phoneNumber
                }
                else if(key == "fullName"){
                    let fullName = (snap as! DataSnapshot).value as! String
                    student.fullName = fullName
                }
                else if(key == "email"){
                    let email = (snap as! DataSnapshot).value as! String
                    student.email = email
                }
            }
            
            if(student.isStudentInfoCompleted()){
                completionHandler(student)
            }
        })
        
        Database.database().reference().child("privateUserProfile").observeSingleEvent(of: .value, with: { (privateSS) in
            
            print(privateSS)
            
            for snap in privateSS.children{
                let key = (snap as! DataSnapshot).key as! String
                if(key == "phoneNumber"){
                    let phoneNumber = (snap as! DataSnapshot).value as! String
                    student.phoneNumber = phoneNumber
                }
                else if(key == "email"){
                    let email = (snap as! DataSnapshot).value as! String
                    student.email = email
                }
            }
            if(student.isStudentInfoCompleted()){
                completionHandler(student)
            }
        })
    }
}
