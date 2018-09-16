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
    var imageUrls: [String:String]!
    var uid:String!
    
    var enrolledIn:[ClassDetail]!
    init(fullname:String,birthYear:String,phoneNumber:String,email:String,uid:String){
        self.fullName = fullname
        self.birthYear = birthYear
        self.phoneNumber = phoneNumber
        self.email = email
        self.imageUrls = [:]
        self.enrolledIn = []
        self.uid = uid
    }
  init(fullname:String,birthYear:String,phoneNumber:String,email:String,uid:String,enrolledIn:[ClassDetail]){
        self.fullName = fullname
        self.birthYear = birthYear
        self.phoneNumber = phoneNumber
        self.email = email
        self.imageUrls = [:]
        self.enrolledIn = enrolledIn
        self.uid = uid
    }
    
    init(userData:UserData){
        self.fullName = userData.fullname
        self.birthYear = userData.birthday
        self.phoneNumber = userData.phoneNumber
        self.email = userData.email
        self.imageUrls = [:]
        self.enrolledIn = []
        self.uid =  userData.uid
    }
    
    
    
    init(){
        self.fullName = nil
        self.birthYear = nil
        self.phoneNumber = nil
        self.email = nil
        self.imageUrls = nil
        self.enrolledIn = []
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
    
    func getOjectKey()-> String{
        return uid
    }
}
