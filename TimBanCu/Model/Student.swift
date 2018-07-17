//
//  Student.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/16/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation

class Student{
    var fullname:String!
    var birthday:String!
    var phoneNumber:String!
    var email:String!
    var imageUrls: [String]!
    
    //var enrolledIn:[String:[String:String]]
  
    
    init(fullname:String,birthday:String,phoneNumber:String,email:String){
        self.fullname = fullname
        self.birthday = birthday
        self.phoneNumber = phoneNumber
        self.email = email
        self.imageUrls = []
    }
    
    init(fullname:String,birthday:String,phoneNumber:String,email:String, imageUrls:[String]){
        self.fullname = fullname
        self.birthday = birthday
        self.phoneNumber = phoneNumber
        self.email = email
        self.imageUrls = imageUrls
    }
}
