//
//  PublicProfile.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/25/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PublicProfile{
    private static let ref = Database.database().reference()
    
    static func addToPersonalEnrollmentListOnFirebase(uid:String, classOrMajor:ClassAndMajorWithYearProtocol){
        ref.child(firebaseEnrolledInPath(uid: uid)).updateChildValues(classOrMajor.objectAsDictionary())
    }
    
    static func firebaseEnrolledInPath(uid:String) ->String{
        return "publicUserProfile/\(uid)/enrolledIn"
    }
    
    static func firebaseGetDataPath(student: Student)->String{
        return "publicUserProfile/\(student.uid!)"
    }
    
    static func getData(student: Student, completionHandler: @escaping () -> Void){
        ref.child(firebaseGetDataPath(student: student)).observeSingleEvent(of: .value, with: {  (publicSS) in
            
            if(!publicSS.hasChildren()){
                completionHandler()
            }
            
            fillInStudent(student: student, snapshot: publicSS)
            
            completionHandler()
            
        })
    }
    
    private static func fillInStudent(student: Student, snapshot:DataSnapshot){
        var birthYear:String!
        var images = [Image]()
        var phoneNumber:String!
        var fullName:String!
        var email:String!
        var enrolledIn = [ClassAndMajorWithYearProtocol]()
        
        for snap in snapshot.children{
            let key = (snap as! DataSnapshot).key
            
            if(key == "birthYear"){
                birthYear = ((snap as! DataSnapshot).value as! String)
            }
            else if(key == "images"){
                let imagesNameAndYear = (snap as! DataSnapshot).value as! [String:String]
            
                for (name,year) in imagesNameAndYear{
                    let image = Image(year: year, imageName: name, uid:student.uid)
                    images.append(image)
                }
            }
            else if(key == "phoneNumber"){
                phoneNumber = ((snap as! DataSnapshot).value as? String)
                if(phoneNumber != nil){
                    student.phoneNumber = phoneNumber
                }
            }
            else if(key == "fullName"){
                fullName = ((snap as! DataSnapshot).value as! String)
            }
            else if(key == "email"){
                email = ((snap as! DataSnapshot).value as? String)
                if(email != nil){
                    student.email = email
                }
            }
            else if(key == "enrolledIn"){
                let enrollments = (snap as! DataSnapshot).value as! [String:Any]
                
                for institutionName in enrollments.keys{
                    let institution = Institution(name: institutionName)
                    
                    let value = enrollments[institutionName] as! [String:String]
                    
                    let uid = value["uid"] as! String
                    let year = value["year"] as! String
                    
                    // if class is ClassDetail
                    if(value["classNumber"] != nil){
                        let className = value["className"] as! String
                        let classNumber = value["classNumber"] as! String
                        
                        
                        let classs = Class(institution: institution, classNumber: classNumber, className: className, uid: uid)
                        
                        let classWithYear = ClassWithYear(classs: classs, year: year)
                        enrolledIn.append(classWithYear)
                    }
                    // if class is MajorDetail
                    else{
                        let majorName = value["majorName"] as! String
                        let major = Major(institution: institution, uid: uid, majorName: majorName)
                        
                        let majorWithYear = MajorWithYear(major: major, year: year)
                        enrolledIn.append(majorWithYear)
                    }
                }
            }
        }
        
        student.birthYear = birthYear
        student.images = images
        
        student.fullName = fullName
        
        student.enrolledIn = enrolledIn
    }
}
