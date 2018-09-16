//
//  PublicData.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/11/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation

enum PrivacyType{
    case Public
    case Private
}

struct UserData{
    
    var phoneNumber:String!
    var email:String!
    var birthday:String!
    var fullname:String!
    
    var imageNameAndYearDic:[String:Int]!
    var phonePrivacy:PrivacyType!
    var emailPrivacy:PrivacyType!
    var uid:String!
    
    init(phoneNumber:String,email:String,birthday:String,fullname:String,phonePrivacyType:String,emailPrivacyType:String,uid:String){
        self.phoneNumber = phoneNumber
        self.email = email
        self.birthday = birthday
        self.fullname = fullname
        self.uid = uid
        
        if(phonePrivacyType == "Công Khai"){
            self.phonePrivacy = .Public
        }
        else{
            self.phonePrivacy = .Private
        }
        
        if(emailPrivacyType == "Công Khai"){
            self.emailPrivacy = .Public
        }
        else{
            self.emailPrivacy = .Private
        }
        
    }
    
    
}
