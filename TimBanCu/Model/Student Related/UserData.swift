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


/*
class UserData:Student{
    let phonePrivacy:PrivacyType
    let emailPrivacy:PrivacyType
    
    private let ref = Database.database().reference()
    
    init(student:Student,phonePrivacyType:PrivacyType,emailPrivacyType:PrivacyType, images:[Image]){
        self.phonePrivacy = phonePrivacyType
        self.emailPrivacy = emailPrivacyType
        
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
        
        ref.child(firebasePublicUploadDataPath()).setValue(publicDic) { [weak self] (publicErr, _) in
            if(publicErr == nil){
                self!.ref.child(self!.firebasePrivateUploadDataPath()).setValue(privateDic, withCompletionBlock: { (privateErr, _) in
                    
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
    
    func firebasePublicUploadDataPath() ->String{
        return "publicUserProfile/\(uid!)"
    }
    
    func firebasePrivateUploadDataPath() ->String{
        return "privateUserProfile/\(uid!)"
    }
    
    func uploadImagesToFirebaseStorage(images:[Image], completionHandler: @escaping (_ status:Status) -> Void){
        
        var imageUploaded = 0
        
        for image in images{
            let name = image.imageName
            let imageRef = storage.child(firebaseStorageImageUploadPath(name: name!))
            
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
    
    func firebaseStorageImageUploadPath(name:String)->String{
        return "users/\(CurrentUser.getUid())/\(name)"
    }
    
    private func getImageNameAndYearDictionary() -> [String:String]{
        var dic = [String:String]()
        
        for image in images{
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
*/
