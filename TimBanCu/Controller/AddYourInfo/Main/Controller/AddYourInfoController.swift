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
    
    fileprivate var classProtocol:ClassAndMajorWithYearProtocol?
    
    fileprivate weak var viewcontroller:AddYourInfoViewController!
    
    init(viewcontroller:AddYourInfoViewController){
        self.viewcontroller = viewcontroller
        self.classProtocol = viewcontroller.classProtocol
    }
    
    private var finishUploadingImagesToStorage = false
    private var finishUploadingDataToDatabase = false
    private var finishEnrollUserToClass = false
    
    // TODO: Write unit test to make sure all the strings are not empty
    func updateUserInfo(images:[Image], completeUploadClosure:@escaping (_ uistate:UIState)->Void){
        
        finishUploadingImagesToStorage = false
        finishUploadingDataToDatabase = false
        finishEnrollUserToClass = false
        
        setUserData(images: images)
        
        updateMyLocalStudentInfo()
        uploadDataToFirebaseDatabase(images: images) { (status) in
            switch(status){
            case .Success():
                self.finishUploadingDataToDatabase = true
                
                if self.isUploadingComplete(){
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
                self.finishUploadingImagesToStorage = true
                if self.isUploadingComplete(){
                    completeUploadClosure(.Success())
                }
                break
            case .Failed(let errMsg):
                completeUploadClosure(.Failure(errMsg))
                break
            }
        }
        
        if shouldEnrollUser(){
            enrollUserIntoClass { (status) in
                switch(status){
                case .Success():
                    self.finishEnrollUserToClass = true
                    if self.isUploadingComplete(){
                        completeUploadClosure(.Success())
                    }
                    break
                case .Failed(let errMsg):
                    completeUploadClosure(.Failure(errMsg))
                    break
                }
            }
        }
    }
    
    private func isUploadingComplete()->Bool{
        if(finishUploadingDataToDatabase && finishUploadingImagesToStorage){
            if shouldEnrollUser(){
                return finishEnrollUserToClass
            }
            else{
                return true
            }
        }
        return false
    }
    
    private func shouldEnrollUser()->Bool{
        return classProtocol != nil
    }
    
    private func enrollUserIntoClass(completionHandler: @escaping (_ status:Status)->()){
        CurrentUser.addEnrollmentLocalAndOnline(classProtocol: classProtocol!) { (uiState) in
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
    
    fileprivate func updateMyLocalStudentInfo(){
        CurrentUser.student = userData
    }
}

// Firebase Database
extension AddYourInfoController{
    
    private func uploadDataToFirebaseDatabase(images:[Image], completionHandler: @escaping (_ status:Status)->()){
        userData.uploadDataToFirebase(images: images, completionHandler: completionHandler)
    }
    
    
}

//Firebase Storage
extension AddYourInfoController{
    fileprivate func uploadUserImagesToFirebaseStorage(images:[Image], completionHandler: @escaping (_ status:Status) -> Void){
        userData.uploadImagesToFirebaseStorage(images: images, completionHandler: completionHandler)
    }
}

// Setup
extension AddYourInfoController{
    
    private func setUserData(images:[Image]){
        let fullname = viewcontroller.fullNameTF.text
        let birthYear = viewcontroller.birthYearTF.text
        let phoneNumber = viewcontroller.phoneTF.text
        let email = viewcontroller.emailTF.text
        
        var phonePrivacy = viewcontroller.phonePrivacyType
        var emailPrivacy = viewcontroller.emailPrivacyType
        
        let student = Student(fullname: fullname!, birthYear: birthYear!, phoneNumber: phoneNumber!, email: email!, uid: CurrentUser.getUid())
        
        if phonePrivacy == nil {
            phonePrivacy = PrivacyType.Public
        }
        if emailPrivacy == nil {
            emailPrivacy = PrivacyType.Public
        }
        
        let userData = UserData(student: student, phonePrivacyType: phonePrivacy!, emailPrivacyType: emailPrivacy!, images: images)
        self.userData = userData
    }
}
