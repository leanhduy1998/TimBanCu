//
//  AddYourInfoDataHandleExtension.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/19/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import Firebase

extension AddYourInfoViewController{
    func updateCurrentStudentInfo(){
        let student = Student(fullname: self.fullNameTF.text!, birthYear: self.birthYearTF.text!, phoneNumber: self.phoneTF.text!, email: self.emailTF.text!, uid: CurrentUser.getUid())
        CurrentUser.setStudent(student: student)
    }
    
    func uploadUserInfoToSelectedClass(){
        Database.database().reference().child(classDetail.getFirebasePathWithSchoolYear()).child(CurrentUser.getUid()).setValue(CurrentUser.getFullname())
    }
    
    func uploadPublicData(imageFileNames:[UIImage:String]){
        var publicDic = [String:Any]()
        
        if(phonePrivacyDropDownBtn.currentTitle == "Công Khai"){
            publicDic["phoneNumber"] = phoneTF.text
        }
        
        if(emailPrivacyDropDownBtn.currentTitle == "Công Khai"){
            publicDic["email"] = emailTF.text
        }
        
        publicDic["birthYear"] = birthYearTF.text
        publicDic["fullName"] = fullNameTF.text
        
        var dic = [String:Int]()
        
        for image in userImages{
            if(yearOfUserImage[image] == nil){
                dic[imageFileNames[image]!] = -1
            }
            else{
                dic[imageFileNames[image]!] = yearOfUserImage[image]
            }
        }
        
        publicDic["images"] = dic
        
        publicUserProfileRef.child(CurrentUser.getUid()).setValue(publicDic)
    }
    
    func uploadPrivateData(){
        var privateDic = [String:Any]()
        
        if(phonePrivacyDropDownBtn.currentTitle == "Chỉ Riêng Tôi"){
            privateDic["phoneNumber"] = phoneTF.text
        }
        
        if(emailPrivacyDropDownBtn.currentTitle == "Chỉ Riêng Tôi"){
            privateDic["email"] = emailTF.text
        }
        
        privateUserProfileRef.child(CurrentUser.getUid()).setValue(privateDic)
    }
    
    func uploadUserImages(imageFileNames:[UIImage:String], completionHandler: @escaping () -> Void){
        
        let storage = Storage.storage()
        
        var imageUploaded = 0
        
        for image in userImages{
            let name = imageFileNames[image]
            let imageRef = storage.reference().child("users").child("\(CurrentUser.getUid())/\(name!)")
            
            let data = image.jpeg(UIImage.JPEGQuality(rawValue: 0.5)!)
            
            let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print()
                    return
                }
                imageUploaded = imageUploaded + 1
                
                if(imageUploaded == imageFileNames.count){
                    completionHandler()
                }
            }
        }
    }
}
