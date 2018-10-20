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
    
    fileprivate let classProtocol:ClassProtocol
    fileprivate var userData:UserData!
    
    fileprivate weak var viewcontroller:AddYourInfoViewController!
    
    init(viewcontroller:AddYourInfoViewController){
        self.viewcontroller = viewcontroller
        self.classProtocol = viewcontroller.classProtocol
        setupFirebaseReference()
    }
    
    // TODO: Write unit test to make sure all the strings are not empty
    func updateUserInfo(images:[Image], completeUploadClosure:@escaping (_ uistate:UIState)->Void){
        
        setUserData(images: images)
        
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
        CurrentUser.addEnrollment(classProtocol: classProtocol) { (uiState) in
            switch(uiState){
            case .Success():
                completionHandler(.Success())
                break
            case .Failure(let errMsg):
                completionHandler(.Failed(errMsg))
                break
            default:
                break
            }
        }
    }
    
    fileprivate func updateCurrentStudentInfo(){
        CurrentUser.setStudent(student: userData.student)
    }
    
    fileprivate func updateLocalCurrentStudent(){
        CurrentUser.setStudent(student: userData.student)
    }
}

// Firebase Database
extension AddYourInfoController{
    fileprivate func uploadUserInfoToSelectedClass(){
        Database.database().reference().child(classProtocol.getFirebasePathWithSchoolYear()).child(CurrentUser.getUid()).setValue(CurrentUser.getFullname())
    }
    
    private func uploadDataToFirebaseDatabase(images:[Image], completionHandler: @escaping (_ status:Status)->()){
        let publicDic = userData.getPublicDataForUpload()
        let privateDic = userData.getPrivateDataForUpload()
        
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
    
    private func setUserData(images:[Image]){
        let fullname = viewcontroller.fullNameTF.text
        let birthYear = viewcontroller.birthYearTF.text
        let phoneNumber = viewcontroller.phoneTF.text
        let email = viewcontroller.emailTF.text
        let phonePrivacy = viewcontroller.phonePrivacyDropDownBtn.currentTitle
        let emailPrivacy = viewcontroller.emailPrivacyDropDownBtn.currentTitle
        
        let student = Student(fullname: fullname!, birthYear: birthYear!, phoneNumber: phoneNumber!, email: email!, uid: CurrentUser.getUid())
        
        let userData = UserData(student: student, phonePrivacyType: phonePrivacy!, emailPrivacyType: emailPrivacy!, images: images)
        self.userData = userData
    }
}
