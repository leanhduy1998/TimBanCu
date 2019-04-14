//
//  StudentManager.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/19/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation

class StudentManager{
    static var shared = StudentManager()
    
    func getPublicDataForUpload(student:Student) -> [String:Any]{
        var publicDic = [String:Any]()
        
        if student.phonePrivacy == PrivacyType.Public{
            publicDic["phoneNumber"] = student.phoneNumber
        }
        if student.emailPrivacy == PrivacyType.Public{
            publicDic["email"] = student.email
        }
        publicDic["birthYear"] = student.birthYear
        publicDic["fullName"] = student.fullName
        publicDic["images"] = getImageNameAndYearDictionary(student: student)
        
        
        return publicDic
    }
    
    func getPrivateDataForUpload(student:Student) -> [String:Any]{
        var privateDic = [String:Any]()
        if student.phonePrivacy == PrivacyType.Private{
            privateDic["phoneNumber"] = student.phoneNumber
        }
        if student.emailPrivacy == PrivacyType.Private{
            privateDic["email"] = student.email
        }
        return privateDic
    }
    
    private func getImageNameAndYearDictionary(student:Student) -> [String:String]{
        var dic = [String:String]()
        
        for image in student.images{
            if(image.year == nil){
                dic[image.imageName] = "?"
            }
            else{
                dic[image.imageName] = image.year
            }
        }
        return dic
    }
}
