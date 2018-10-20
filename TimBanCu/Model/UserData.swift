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

class UserData{
    let phonePrivacy:PrivacyType
    let emailPrivacy:PrivacyType
    let student:Student
    let images:[Image]
    
    init(student:Student,phonePrivacyType:String,emailPrivacyType:String, images:[Image]){
        self.student = student
        self.images = images
        
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
    
    func getPublicDataForUpload() -> [String:Any]{
        var publicDic = [String:Any]()
        if phonePrivacy == PrivacyType.Public{
            publicDic["phoneNumber"] = student.phoneNumber
        }
        if emailPrivacy == PrivacyType.Public{
            publicDic["email"] = student.email
        }
        publicDic["birthYear"] = student.birthYear
        publicDic["fullName"] = student.fullName
        publicDic["images"] = getImageNameAndYearDictionary()
        
        return publicDic
    }
    
    func getPrivateDataForUpload() -> [String:Any]{
        var privateDic = [String:Any]()
        if phonePrivacy == PrivacyType.Private{
            privateDic["phoneNumber"] = student.phoneNumber
        }
        if emailPrivacy == PrivacyType.Private{
            privateDic["email"] = student.email
        }
        return privateDic
    }
    
    private func getImageNameAndYearDictionary() -> [String:String]{
        var dic = [String:String]()
        
        for image in images{
            if(image.year == nil){
                dic[image.imageName] = "-1"
            }
            else{
                dic[image.imageName] = image.year
            }
        }
        return dic
    }
    
    
}
