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
    var imageUrls: [String]!
    var uid:String!
    
    var enrolledIn:[String:[String:String]]
  init(fullname:String,birthYear:String,phoneNumber:String,email:String,uid:String){
        self.fullName = fullname
        self.birthYear = birthYear
        self.phoneNumber = phoneNumber
        self.email = email
        self.imageUrls = []
        self.enrolledIn = [:]
        self.uid = uid
    }
    
    init(fullname:String,birthYear:String,phoneNumber:String,email:String, imageUrls:[String],uid:String){
        self.fullName = fullname
        self.birthYear = birthYear
        self.phoneNumber = phoneNumber
        self.email = email
        self.imageUrls = imageUrls
        self.enrolledIn = [:]
        self.uid = uid
    }
    
    func getObjectValueAsDic() -> [String:Any]{
        return ["fullName":fullName,"birthday":birthYear,"phoneNumber":phoneNumber,"email":email,"imageUrls":imageUrls,"enrolledIn":enrolledIn]
    }
    
    func getOjectKey()-> String{
        return uid
    }
}
