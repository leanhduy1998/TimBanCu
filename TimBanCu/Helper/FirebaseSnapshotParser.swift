//
//  FirebaseSnapshotParser.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/10/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseSnapshotParser{
    static func getInstitutions(from snapshot:DataSnapshot,educationLevel:EducationLevel)->[InstitutionFull]{
        
        var institutions = [InstitutionFull]()
        
        for snap in snapshot.children {
            let name = (snap as! DataSnapshot).key
            let valueDic = (snap as! DataSnapshot).value as! [String:Any]
            let address = valueDic["address"] as? String
            let uid = valueDic["uid"] as? String
            
            let institution = InstitutionFull(name: name, address: address, type: educationLevel.getShortString(), addByUid: uid!)
            
            institutions.append(institution)
        }
        
        return institutions
    }
    
    static func getClasses(from snapshot:DataSnapshot,institution:Institution,classNumber:String)->[Class]{
        
        var classes = [Class]()
        
        for snap in snapshot.children{
            let className = (snap as! DataSnapshot).key
            
            let value = (snap as! DataSnapshot).value as! [String:Any]
            let createdByUid = value["createdBy"] as! String
            
            let classN = Class(institution: institution, classNumber: classNumber, className: className, uid: createdByUid)
            classes.append(classN)
            
        }
        
        return classes
    }
    
    static func getMajors(from snapshot:DataSnapshot, institution:Institution) -> [Major]{
        var majors = [Major]()
        
        for snap in snapshot.children{
            let majorName = (snap as! DataSnapshot).key
            
            let value = (snap as! DataSnapshot).value as! [String:Any]
            let createdByUid = value["createdBy"] as! String
            
            let major = Major(institution: institution, uid: createdByUid, majorName: majorName)
            
            majors.append(major)
        }
        return majors
    }
    
    static func getStudent(uid:String, publicSS:DataSnapshot, privateSS:DataSnapshot)->Student?{
        var birthYear:String!
        var images = [Image]()
        var phoneNumber:String!
        var fullName:String!
        var email:String!
        var enrolledIn = [ClassAndMajorWithYearProtocol]()
        
        for snap in publicSS.children{
            let snap = snap as! DataSnapshot
            
            let key = snap.key
            
            if(key == "birthYear"){
                if let value = snap.value as? String{
                    birthYear = value
                }
            }
            else if(key == "images"){
                if let imagesNameAndYear = snap.value as? [String:String]{
                    for (name,year) in imagesNameAndYear{
                        let image = Image(year: year, imageName: name, uid:uid)
                        images.append(image)
                    }
                }
            }
            else if(key == "phoneNumber"){
                if let value = snap.value as? String{
                    phoneNumber = value
                }
            }
            else if(key == "fullName"){
                if let value = snap.value as? String{
                    fullName = value
                }
            }
            else if(key == "email"){
                if let value = snap.value as? String{
                    email = value
                }
            }
            else if(key == "enrolledIn"){
                if let enrollments = snap.value as? [String:Any] {
                    for (institutionName, institutionValue) in enrollments{
                        guard let institutionValue = institutionValue as? [String:String] else{
                            continue
                        }
                        
                        if let enrollment = getEnrollment(institutionName: institutionName, institutionValue: institutionValue){
                            
                            enrolledIn.append(enrollment)
                        }
                    }
                }
            }
        }
        
        for snap in privateSS.children{
            let snap = snap as! DataSnapshot
            
            let key = snap.key
            if(key == "phoneNumber"){
                if let value = snap.value as? String{
                    phoneNumber = value
                }
            }
            else if(key == "email"){
                if let value = snap.value as? String{
                    email = value
                }
            }
        }
        
        let student = Student()
        
        student.birthYear = birthYear
        student.images = images
        student.fullName = fullName
        student.enrolledIn = enrolledIn
        student.phoneNumber = phoneNumber
        student.email = email
        return student
    }
    
    private static func getEnrollment(institutionName:String, institutionValue:[String:String])->ClassAndMajorWithYearProtocol?{
        
        let institution = Institution(name: institutionName)
        
        guard let uid = institutionValue["uid"] else{
            return nil
        }
        guard let year = institutionValue["year"] else{
            return nil
        }
        
        // if class is ClassDetail
        if(institutionValue["classNumber"] != nil){
            guard let className = institutionValue["className"] else{
                return nil
            }
            guard let classNumber = institutionValue["classNumber"] else{
                return nil
            }
            
            let classs = Class(institution: institution, classNumber: classNumber, className: className, uid: uid)
            
            let classWithYear = ClassWithYear(classs: classs, year: year)
            return classWithYear
        }
            // if class is MajorDetail
        else{
            guard let majorName = institutionValue["majorName"] else{
                return nil
            }
            let major = Major(institution: institution, uid: uid, majorName: majorName)
            
            let majorWithYear = MajorWithYear(major: major, year: year)
            return majorWithYear
        }
    }
}
