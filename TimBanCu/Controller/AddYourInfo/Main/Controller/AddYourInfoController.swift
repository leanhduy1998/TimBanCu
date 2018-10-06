//
//  AddYourInfoController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/11/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class AddYourInfoController{
    fileprivate var privateUserProfileRef:DatabaseReference!
    fileprivate var publicUserProfileRef:DatabaseReference!
    
    fileprivate var classProtocol:ClassProtocol!
    fileprivate var userData:UserData!
    
    fileprivate weak var viewcontroller:AddYourInfoViewController!
    
    init(viewcontroller:AddYourInfoViewController){
        self.viewcontroller = viewcontroller
        self.classProtocol = viewcontroller.classProtocol
        setupFirebaseReference()
    }
    
    // TODO: Write unit test to make sure all the strings are not empty
    func updateUserInfo(images:[Image], completeUploadClosure:@escaping (_ uistate:UIState)->Void){
        
        setUserData()
        
        updateLocalCurrentStudent()
        updateCurrentStudentInfo()
        
        var finishUploadingImagesToStorage = false
        var finishUploadingDataToDatabase = false
        var finishEnrollUserToClass = false
        
        uploadDataToFirebaseDatabase(images: images) { (status) in
            switch(status){
            case .Success():
                finishUploadingDataToDatabase = true
                if(finishUploadingImagesToStorage && finishEnrollUserToClass){
                    completeUploadClosure(.Success())
                }
                break
            case .Failed(let errMsg):
                completeUploadClosure(.Failure(errMsg))
                break
            }
        }
        
        
        uploadUserImagesToFirebaseStorage(images: images) { (status) in
            switch(status){
            case .Success():
                finishUploadingImagesToStorage = true
                if(finishUploadingDataToDatabase && finishEnrollUserToClass){
                    completeUploadClosure(.Success())
                }
                break
            case .Failed(let errMsg):
                completeUploadClosure(.Failure(errMsg))
                break
            }
        }
        
        enrollUserIntoClass { (status) in
            switch(status){
            case .Success():
                finishEnrollUserToClass = true
                if(finishUploadingDataToDatabase && finishUploadingImagesToStorage){
                    completeUploadClosure(.Success())
                }
                break
            case .Failed(let errMsg):
                completeUploadClosure(.Failure(errMsg))
                break
            }
        }
    }
    
    private func enrollUserIntoClass(completionHandler: @escaping (_ status:Status)->()){
        let classEnrollRef = Database.database().reference().child("students").child(classProtocol.getFirebasePathWithSchoolYear())
        classEnrollRef.child(CurrentUser.getUid()).setValue(CurrentUser.getFullname()) { (error, ref) in
            if(error == nil){
                completionHandler(.Success())
            }
            else{
                completionHandler(.Failed((error?.localizedDescription)!))
            }
        }
    }
    
    fileprivate func updateCurrentStudentInfo(){
        let student = Student(fullname: userData.fullname, birthYear: userData.birthday, phoneNumber: userData.phoneNumber, email: userData.email, uid: CurrentUser.getUid())
        CurrentUser.setStudent(student: student)
    }
    
    fileprivate func updateLocalCurrentStudent(){
        let student = Student(userData: userData)
        CurrentUser.setStudent(student: student)
    }
}

// Firebase Database
extension AddYourInfoController{
    fileprivate func uploadUserInfoToSelectedClass(){
        Database.database().reference().child(classProtocol.getFirebasePathWithSchoolYear()).child(CurrentUser.getUid()).setValue(CurrentUser.getFullname())
    }
    
    private func uploadDataToFirebaseDatabase(images:[Image], completionHandler: @escaping (_ status:Status)->()){
        let publicDic = getPublicDataForUpload(images: images)
        let privateDic = getPrivateDataForUpload()
        
        publicUserProfileRef.child(CurrentUser.getUid()).setValue(publicDic) { (publicErr, _) in
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
    
    private func getPublicDataForUpload(images:[Image]) -> [String:Any]{
        var publicDic = [String:Any]()
        if userData.phonePrivacy == PrivacyType.Public{
            publicDic["phoneNumber"] = userData.phoneNumber
        }
        if userData.emailPrivacy == PrivacyType.Public{
            publicDic["email"] = userData.email
        }
        publicDic["birthYear"] = userData.birthday
        publicDic["fullName"] = userData.fullname
        publicDic["images"] = getImageNameAndYearDictionary(images: images)
        
        return publicDic
    }
    
    private func getPrivateDataForUpload() -> [String:Any]{
        var privateDic = [String:Any]()
        if userData.phonePrivacy == PrivacyType.Private{
            privateDic["phoneNumber"] = userData.phoneNumber
        }
        if userData.emailPrivacy == PrivacyType.Private{
            privateDic["email"] = userData.email
        }
        return privateDic
    }
    
    private func getImageNameAndYearDictionary(images:[Image]) -> [String:String]{
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

//Firebase Storage
extension AddYourInfoController{
    fileprivate func uploadUserImagesToFirebaseStorage(images:[Image], completionHandler: @escaping (_ status:Status) -> Void){
        
        let storage = Storage.storage()
        
        var imageUploaded = 0
        
        for image in images{
            let name = image.imageName
            let imageRef = storage.reference().child("users").child("\(CurrentUser.getUid())/\(name!)")
            
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
}

// Setup
extension AddYourInfoController{
    private func setupFirebaseReference(){
        privateUserProfileRef = Database.database().reference().child("privateUserProfile")
        publicUserProfileRef = Database.database().reference().child("publicUserProfile")
    }
    
    private func setUserData(){
        let fullname = viewcontroller.fullNameTF.text
        let birthYear = viewcontroller.birthYearTF.text
        let phoneNumber = viewcontroller.phoneTF.text
        let email = viewcontroller.emailTF.text
        let phonePrivacy = viewcontroller.phonePrivacyDropDownBtn.currentTitle
        let emailPrivacy = viewcontroller.emailPrivacyDropDownBtn.currentTitle
        
        let userData = UserData(phoneNumber: phoneNumber!, email: email!, birthday: birthYear!, fullname: fullname!, phonePrivacyType: phonePrivacy!, emailPrivacyType: emailPrivacy!, uid: CurrentUser.getUid())
        self.userData = userData
    }
}
