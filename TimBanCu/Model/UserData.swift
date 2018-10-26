//
//  PublicData.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/11/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

enum PrivacyType{
    case Public
    case Private
}

class UserData:Student{
    let phonePrivacy:PrivacyType
    let emailPrivacy:PrivacyType
    
    private let privateUserProfileRef = Database.database().reference().child("privateUserProfile")
    private let publicUserProfileRef = Database.database().reference().child("publicUserProfile")
    
    init(student:Student,phonePrivacyType:String,emailPrivacyType:String, images:[Image]){
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
        
        super.init(student: student)
        self.images.append(contentsOf: images)
    }
   
    
    private func getPublicDataForUpload() -> [String:Any]{
        var publicDic = [String:Any]()
        if phonePrivacy == PrivacyType.Public{
            publicDic["phoneNumber"] = phoneNumber
        }
        if emailPrivacy == PrivacyType.Public{
            publicDic["email"] = email
        }
        publicDic["birthYear"] = birthYear
        publicDic["fullName"] = fullName
        publicDic["images"] = getImageNameAndYearDictionary()
        
        
        return publicDic
    }
    
    private func getPrivateDataForUpload() -> [String:Any]{
        var privateDic = [String:Any]()
        if phonePrivacy == PrivacyType.Private{
            privateDic["phoneNumber"] = phoneNumber
        }
        if emailPrivacy == PrivacyType.Private{
            privateDic["email"] = email
        }
        return privateDic
    }
    
    func uploadDataToFirebase(images:[Image], completionHandler: @escaping (_ status:Status)->()){
        let publicDic = getPublicDataForUpload()
        let privateDic = getPrivateDataForUpload()
        
        publicUserProfileRef.child(uid).setValue(publicDic) { (publicErr, _) in
            if(publicErr == nil){
                self.privateUserProfileRef.child(CurrentUser.getUid()).setValue(privateDic, withCompletionBlock: { (privateErr, _) in
                    
                    
                    if(privateErr == nil){
                        completionHandler(.Success())
                    }
                    else{
                        completionHandler(.Failed(privateErr.debugDescription))
                    }
                    
                })
            }
            else{
                completionHandler(.Failed(publicErr.debugDescription))
            }
        }
    }
    
    func uploadImagesToFirebaseStorage(images:[Image], completionHandler: @escaping (_ status:Status) -> Void){
        
        var imageUploaded = 0
        
        for image in images{
            let name = image.imageName
            let imageRef = storage.child("users").child("\(CurrentUser.getUid())/\(name!)")
            
            let data = image.image?.jpeg(UIImage.JPEGQuality(rawValue: 0.5)!)
            
            let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    completionHandler(.Failed(error.debugDescription))
                    return
                }
                imageUploaded = imageUploaded + 1
                
                if(imageUploaded == images.count){
                    completionHandler(.Success())
                }
            }
        }
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
