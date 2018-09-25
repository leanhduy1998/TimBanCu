//
//  AllUserHelper.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/18/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class AllUserHelper{
    static func getAnyStudentFromDatabase(uid:String,completionHandler: @escaping (_ student:Student) -> Void){
        getPublicData(uid: uid, completionHandler: completionHandler)
    }
    
    
    
    private static func getPublicData(uid:String,completionHandler: @escaping (_ student:Student) -> Void){
        let student = Student()
        student.uid = uid
        Database.database().reference().child("publicUserProfile").child(uid).observeSingleEvent(of: .value, with: { (publicSS) in
            
            if(!publicSS.hasChildren()){
                completionHandler(Student())
            }
            
            for snap in publicSS.children{
                let key = (snap as! DataSnapshot).key 
                
                if(key == "birthYear"){
                    let birthYear = (snap as! DataSnapshot).value as! String
                    student.birthYear = birthYear
                }
                else if(key == "images"){
                    let imagesNameAndYear = (snap as! DataSnapshot).value as! [String:String]
                    
                    var images = [Image]()
                    
                    for (name,year) in imagesNameAndYear{
                        let image = Image(year: year, imageName: name)
                        images.append(image)
                    }
                    
                    student.images = images
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
                else if(key == "enrolledIn"){
                    let classArray = (snap as! DataSnapshot).value as! [[String:String]]
                    
                    for classDic in classArray{
                        let classDetail = ClassDetail(classDic: classDic)
                        student.enrolledIn.append(classDetail)
                    }
                }
            }
            
            getPrivateData(student: student, completionHandler: completionHandler)
            
        })
    }
    
    private static func getPrivateData(student:Student,completionHandler: @escaping (_ student:Student) -> Void){
        
        Database.database().reference().child("privateUserProfile").child(student.uid).observeSingleEvent(of: .value, with: { (privateSS) in
            
            if(!privateSS.hasChildren()){
                completionHandler(student)
            }
            else{
                for snap in privateSS.children{
                    let key = (snap as! DataSnapshot).key
                    if(key == "phoneNumber"){
                        let phoneNumber = (snap as! DataSnapshot).value as! String
                        student.phoneNumber = phoneNumber
                    }
                    else if(key == "email"){
                        let email = (snap as! DataSnapshot).value as! String
                        student.email = email
                    }
                }
                
                completionHandler(student)
            }
            
            
        }) { (err) in
            if(err.localizedDescription == "Permission Denied"){
                completionHandler(student)
            }
        }

    }
}
