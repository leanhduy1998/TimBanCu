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
    
    fileprivate var classDetail:ClassDetail!
    fileprivate var userData:UserData!
    
    fileprivate weak var viewcontroller:AddYourInfoViewController!
    
    init(viewcontroller:AddYourInfoViewController,classDetail:ClassDetail){
        self.classDetail = classDetail
        self.viewcontroller = viewcontroller
        
        setupFirebaseReference()
    }
    
    private func setupFirebaseReference(){
        privateUserProfileRef = Database.database().reference().child("privateUserProfile")
        publicUserProfileRef = Database.database().reference().child("publicUserProfile")
    }
    
    // TODO: Write unit test to make sure all the strings are not empty
    func updateUserInfo(images:[Image], completeUploadClosure:@escaping ()->Void){
        
        let fullname = viewcontroller.fullNameTF.text
        let birthYear = viewcontroller.birthYearTF.text
        let phoneNumber = viewcontroller.phoneTF.text
        let email = viewcontroller.emailTF.text
        let phonePrivacy = viewcontroller.phonePrivacyDropDownBtn.currentTitle
        let emailPrivacy = viewcontroller.emailPrivacyDropDownBtn.currentTitle
        
        let userData = UserData(phoneNumber: phoneNumber!, email: email!, birthday: birthYear!, fullname: fullname!, phonePrivacyType: phonePrivacy!, emailPrivacyType: emailPrivacy!, uid: CurrentUser.getUid())
        self.userData = userData
        
        updateLocalCurrentStudent()
        uploadDataToFirebaseDatabase(images: images)
        uploadUserImagesToFirebaseStorage(images: images, completionHandler: completeUploadClosure)
        updateCurrentStudentInfo()
        
    }
    
    fileprivate func updateCurrentStudentInfo(){
        let student = Student(fullname: userData.fullname, birthYear: userData.birthday, phoneNumber: userData.phoneNumber, email: userData.email, uid: CurrentUser.getUid())
        CurrentUser.setStudent(student: student)
    }
}

extension AddYourInfoController{
    fileprivate func updateLocalCurrentStudent(){
        let student = Student(userData: userData)
        CurrentUser.setStudent(student: student)
    }
    
    fileprivate func uploadUserInfoToSelectedClass(){
        Database.database().reference().child(classDetail.getFirebasePathWithSchoolYear()).child(CurrentUser.getUid()).setValue(CurrentUser.getFullname())
    }
    
 
    
    private func uploadDataToFirebaseDatabase(images:[Image]){
        var publicDic = [String:Any]()
        var privateDic = [String:Any]()
        
        switch(userData.phonePrivacy!){
        case .Public:
            publicDic["phoneNumber"] = userData.phoneNumber
            break
        default:
            privateDic["phoneNumber"] = userData.phoneNumber
            break
        }
        
        switch(userData.emailPrivacy!){
        case .Public:
            publicDic["email"] = userData.email
            break
        default:
            privateDic["email"] = userData.email
            break
        }
        
        publicDic["birthYear"] = userData.birthday
        publicDic["fullName"] = userData.fullname
        
        var dic = [String:String]()
        
        for image in images{
            if(image.year == nil){
                dic[image.imageName] = "-1"
            }
            else{
                dic[image.imageName] = image.year
            }
        }
        
        publicDic["images"] = dic
        
        publicUserProfileRef.child(CurrentUser.getUid()).setValue(publicDic)
        privateUserProfileRef.child(CurrentUser.getUid()).setValue(privateDic)
    }
    
    private func uploadUserImagesToFirebaseStorage(images:[Image], completionHandler: @escaping () -> Void){
        
        let storage = Storage.storage()
        
        var imageUploaded = 0
        
        for image in images{
            let name = image.imageName
            let imageRef = storage.reference().child("users").child("\(CurrentUser.getUid())/\(name!)")
            
            let data = image.image?.jpeg(UIImage.JPEGQuality(rawValue: 0.5)!)
            
            let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print()
                    return
                }
                imageUploaded = imageUploaded + 1
                
                if(imageUploaded == images.count){
                    completionHandler()
                }
            }
        }
    }
}
