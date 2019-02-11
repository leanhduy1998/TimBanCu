//
//  Student.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/16/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class Student{
    var fullName:String!
    var birthYear:String!
    var phoneNumber:String!
    var email:String!
    var images: [Image]!
    var uid:String!
    
    var storage = Storage.storage().reference()
    
    var enrolledIn:[ClassAndMajorWithYearProtocol]!
    init(fullname:String,birthYear:String,phoneNumber:String,email:String,uid:String){
        self.fullName = fullname
        self.birthYear = birthYear
        self.phoneNumber = phoneNumber
        self.email = email
        self.images = []
        self.enrolledIn = []
        self.uid = uid
    }
  init(fullname:String,birthYear:String,phoneNumber:String,email:String,uid:String,enrolledIn:[ClassAndMajorWithYearProtocol]){
        self.fullName = fullname
        self.birthYear = birthYear
        self.phoneNumber = phoneNumber
        self.email = email
        self.images = []
        self.enrolledIn = enrolledIn
        self.uid = uid
    }
    
    
    init(){
        self.fullName = nil
        self.birthYear = nil
        self.phoneNumber = nil
        self.email = nil
        self.images = []
        self.enrolledIn = []
        self.uid = nil
    }
    
    init(student:Student){
        self.fullName = student.fullName
        self.birthYear = student.birthYear
        self.phoneNumber = student.phoneNumber
        self.email = student.email
        self.images = student.images
        self.enrolledIn = student.enrolledIn
        self.uid = student.uid
    }
    
    func isStudentInfoCompleted() -> Bool{
        if(fullName == nil || fullName.isEmpty){
            return false
        }
        if(birthYear == nil || birthYear.isEmpty){
            return false
        }
        if(phoneNumber == nil || phoneNumber.isEmpty){
            return false
        }
        if(email == nil || email.isEmpty){
            return false
        }
        if(uid == nil || uid.isEmpty){
            return false
        }
        return true
    }
    
    func getModelAsDictionary() -> [String:Any]{
        var imageNameAndYear = [String:String]()
        for image in images{
            if(image.year == nil){
                imageNameAndYear[image.imageName] = "?"
            }
            else{
                imageNameAndYear[image.imageName] = image.year
            }
        }
        
        return ["fullName":fullName!,"birthYear":birthYear!,"phoneNumber":phoneNumber!,"email":email!,"imageUrls":imageNameAndYear,"enrolledIn":enrolledIn]
    }
}
