//
//  Student.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/16/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation

class Student{
    var fullName:String!
    var birthYear:String!
    var phoneNumber:String!
    var email:String!
    var imageUrls: [String:Int]!
    var uid:String!
    
    //var enrolledIn:[String:[String:String]]
  init(fullname:String,birthYear:String,phoneNumber:String,email:String,uid:String){
        self.fullName = fullname
        self.birthYear = birthYear
        self.phoneNumber = phoneNumber
        self.email = email
        self.imageUrls = [:]
     //   self.enrolledIn = [:]
        self.uid = uid
    }
    
    init(fullname:String,birthYear:String,phoneNumber:String,email:String, imageUrls:[String:Int],uid:String){
        self.fullName = fullname
        self.birthYear = birthYear
        self.phoneNumber = phoneNumber
        self.email = email
        self.imageUrls = imageUrls
    //    self.enrolledIn = [:]
        self.uid = uid
    }
    
    init(){
        self.fullName = nil
        self.birthYear = nil
        self.phoneNumber = nil
        self.email = nil
        self.imageUrls = nil
    //    self.enrolledIn = [:]
        self.uid = nil
    }
    
    func isStudentInfoCompleted() -> Bool{
        if(fullName == nil){
            return false
        }
        if(birthYear == nil){
            return false
        }
        if(phoneNumber == nil){
            return false
        }
        if(email == nil){
            return false
        }
        if(imageUrls == nil){
            return false
        }
        /*if(enrolledIn == nil){
            return false
        }*/
        if(uid == nil){
            return false
        }
        return true
    }
    
    func getObjectValueAsDic() -> [String:Any]{
        //return ["fullName":fullName,"birthday":birthYear,"phoneNumber":phoneNumber,"email":email,"imageUrls":imageUrls,"enrolledIn":enrolledIn]
        return ["fullName":fullName,"birthday":birthYear,"phoneNumber":phoneNumber,"email":email,"imageUrls":imageUrls]
    }
    
    func getOjectKey()-> String{
        return uid
    }
}
