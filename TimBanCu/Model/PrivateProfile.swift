//
//  PrivateProfile.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/25/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PrivateProfile{
    private static let privateUserProfileRef = Database.database().reference().child("privateUserProfile")
    
    static func addToPersonalEnrollmentListOnFirebase(uid:String, classOrMajor:ClassAndMajorWithYearProtocol){
        privateUserProfileRef.child("\(uid)/enrolledIn").updateChildValues(classOrMajor.objectAsDictionary())
    }
    
    static func getData(student: Student, completionHandler: @escaping () -> Void){
        privateUserProfileRef.child(student.uid).observeSingleEvent(of: .value, with: {  (privateSS) in
            
            if(!privateSS.hasChildren()){
                completionHandler()
            }
            
            fillInStudent(student: student, snapshot: privateSS)
            
            completionHandler()
            
        })
    }
    
    private static func fillInStudent(student: Student, snapshot:DataSnapshot){
        var phoneNumber:String!
        var email:String!
        
        for snap in snapshot.children{
            let key = (snap as! DataSnapshot).key
            if(key == "phoneNumber"){
                phoneNumber = (snap as! DataSnapshot).value as! String
            }
            else if(key == "email"){
                email = (snap as! DataSnapshot).value as! String
            }
        }

        student.phoneNumber = phoneNumber
        student.email = email
    }
}

