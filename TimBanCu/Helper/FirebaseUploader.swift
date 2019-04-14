//
//  FirebaseUploader.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/10/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseUploader{
    static var shared = FirebaseUploader()
    
    private let ref = Database.database().reference()
    private let storageUploader = FirebaseStorageUploader()
    
    func uploadInstitution(institution:InstitutionFull,completionHandler: @escaping (Error?,DatabaseReference)->Void){
        
        var dic:[String:Any] = ["type":institution.type,"uid":institution.addByUid]
        if(institution.address != nil){
            dic["address"] = institution.address
        }
        ref.child("schools/\(institution.name!)").setValue(dic, withCompletionBlock: completionHandler)
    }
    
    func uploadClass(classs:Class,completionHandler: @escaping (_ state:UIState)->Void){
        
        let path = "classes/\(classs.institution.name!)/\(classs.classNumberString)/\(classs.classNameString)/createdBy"
        
        ref.child(path).setValue(classs.uid) { (err, _) in
            if(err == nil){
                completionHandler(.Success())
            }
            else{
                completionHandler(.Failure(err.debugDescription))
            }
        }
    }
    
    func uploadClass(uid:String,model:ClassWithYear,completionHandler: @escaping (UIState) -> Void) {
        
        let path = "classes/\(model.institution.name!)/\(model.classNumberString)/\(model.classNameString)/\(model.year)"
        
        ref.child(path).setValue(uid) { (err, _) in
            if(err == nil){
                completionHandler(.Success())
            }
            else{
                completionHandler(.Failure(err.debugDescription))
            }
        }
    }
    
    func enroll(student:Student, model:ClassAndMajorWithYearProtocol,completionHandler: @escaping (_ uiState:UIState) -> Void){
        
        if model is ClassWithYear{
            enroll(student: student, to: model as! ClassWithYear, completionHandler: completionHandler)
        }
        else{
            enroll(student: student, to: model as! MajorWithYear, completionHandler: completionHandler)
        }
        
    }
    
    private func enroll(student:Student, to classs:ClassWithYear,completionHandler: @escaping (_ uiState:UIState) -> Void) {
        
        let path = "classes/\(classs.institution.name!)/\(classs.classNumberString)/\(classs.classNameString)/\(classs.year)"
        ref.child(path).child(student.uid).setValue(student.fullName) { [weak self] (err, _) in
            
            guard let strongself = self else{
                return
            }
            
            if(err == nil){
                strongself.updateStudentEnrollList(uid: student.uid, to: classs, completionHandler: completionHandler)
            }
            else{
                completionHandler(.Failure((err?.localizedDescription)!))
            }
        }
    }
    
    private func enroll(student:Student, to major:MajorWithYear,completionHandler: @escaping (_ uiState:UIState) -> Void) {
        
        let path = "classes/\(major.institution.name!)/\(major.name!)/\(major.year)"
        ref.child(path).child(student.uid).setValue(student.fullName) { [weak self] (err, _) in
            
            guard let strongself = self else{
                return
            }
            
            if(err == nil){
                strongself.updateStudentEnrollList(uid: student.uid, to: major, completionHandler: completionHandler)
            }
            else{
                completionHandler(.Failure((err?.localizedDescription)!))
            }
        }
    }
    
    func uploadMajor(model:Major, completionHandler: @escaping (_ err:String?)->Void){
        let path = "classes/\(model.institution.name!)/\(model.name!)/createdBy"
        
        ref.child(path).setValue(model.uid) { (err, _) in
            if(err == nil){
                completionHandler(nil)
            }
            else{
                completionHandler(err.debugDescription)
            }
        }
    }
    
    func uploadMajor(model:MajorWithYear, uid:String, completionHandler: @escaping (_ state:UIState)->Void){
        let path = "classes/\(model.institution.name!)/\(model.name!)/\(model.year)"
        
        ref.child(path).setValue(uid) { (err, _) in
            if(err == nil){
                completionHandler(.Success())
            }
            else{
                completionHandler(.Failure(err.debugDescription))
            }
        }
    }
    
    
    private func updateStudentEnrollList(uid:String,to model:ClassAndMajorWithYearProtocol,completionHandler: @escaping (_ uiState:UIState) -> Void){
        let path = "publicUserProfile/\(uid)/enrolledIn"
        ref.child(path).updateChildValues(model.objectAsDictionary(), withCompletionBlock: { (err, _) in
            
            if err == nil{
                completionHandler(.Success())
            }
            else{
                completionHandler(.Failure("Không thể cập nhập thông tin"))
            }
            
        })
    }
    
    
    private var publicDataUploaded = false
    private var privateDataUploaded = false
    private var userImagesUploaded = false
    
    func uploadStudentDetailedData(student:Student, completionHandler:@escaping (_ _state:UIState)->Void){
        publicDataUploaded = false
        privateDataUploaded = false
        userImagesUploaded = false
        
        let publicPath = "publicUserProfile/\(student.uid!)"
        let privatePath = "privateUserProfile/\(student.uid!)"
        
        let publicData = StudentManager.shared.getPublicDataForUpload(student: student)
        let privateData = StudentManager.shared.getPrivateDataForUpload(student: student)
        
        let ref = self.ref
        
        ref.child(publicPath).setValue(publicData) { [weak self] (publicErr, _) in
            guard let strongself = self else{
                return
            }
            
            if(publicErr == nil){
                strongself.publicDataUploaded = true
                if strongself.isUploadStudentComplete(){
                    completionHandler(.Success())
                }
            }
            else{
                completionHandler(.Failure(publicErr.debugDescription))
            }
        }
        
        ref.child(privatePath).setValue(privateData, withCompletionBlock: { [weak self] (privateErr, _) in
            
            guard let strongself = self else{
                return
            }
            
            if(privateErr == nil){
                strongself.privateDataUploaded = true
                if strongself.isUploadStudentComplete(){
                    completionHandler(.Success())
                }
            }
            else{
                completionHandler(.Failure(privateErr.debugDescription))
            }
            
        })
        
        storageUploader.uploadImagesToStorage(images: student.images) {[weak self] (err) in
            guard let strongself = self else{
                return
            }
            
            if err == nil{
                strongself.userImagesUploaded = true
                if strongself.isUploadStudentComplete(){
                    completionHandler(.Success())
                }
            }
            else{
                completionHandler(.Failure(err!))
            }
        }
    }
    
    private func isUploadStudentComplete()->Bool{
        return publicDataUploaded && privateDataUploaded && userImagesUploaded
    }
    
    
    
    
    
    
}
