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
    private static let ref = Database.database().reference()
    
    static func uploadInstitution(institution:InstitutionFull,completionHandler: @escaping (Error?,DatabaseReference)->Void){
        
        var dic:[String:Any] = ["type":institution.type,"uid":institution.addByUid]
        if(institution.address != nil){
            dic["address"] = institution.address
        }
        ref.child("schools/\(institution.name!)").setValue(dic, withCompletionBlock: completionHandler)
    }
    
    static func uploadClass(classs:Class,completionHandler: @escaping (_ state:UIState)->Void){
        
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
    
    static func uploadClass(uid:String,model:ClassWithYear,completionHandler: @escaping (UIState) -> Void) {
        
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
    
    static func enroll(student:Student, model:ClassAndMajorWithYearProtocol,completionHandler: @escaping (_ uiState:UIState) -> Void){
        
        if model is ClassWithYear{
            enroll(student: student, to: model as! ClassWithYear, completionHandler: completionHandler)
        }
        else{
            enroll(student: student, to: model as! MajorWithYear, completionHandler: completionHandler)
        }
        
    }
    
    private static func enroll(student:Student, to classs:ClassWithYear,completionHandler: @escaping (_ uiState:UIState) -> Void) {
        
        let path = "classes/\(classs.institution.name!)/\(classs.classNumberString)/\(classs.classNameString)/\(classs.year)"
        ref.child(path).child(student.uid).setValue(student.fullName) { (err, _) in
            if(err == nil){
                updateStudentEnrollList(uid: student.uid, to: classs, completionHandler: completionHandler)
            }
            else{
                completionHandler(.Failure((err?.localizedDescription)!))
            }
        }
    }
    
    private static func enroll(student:Student, to major:MajorWithYear,completionHandler: @escaping (_ uiState:UIState) -> Void) {
        
        let path = "classes/\(major.institution.name!)/\(major.name!)/\(major.year)"
        ref.child(path).child(student.uid).setValue(student.fullName) { (err, _) in
            if(err == nil){
                updateStudentEnrollList(uid: student.uid, to: major, completionHandler: completionHandler)
            }
            else{
                completionHandler(.Failure((err?.localizedDescription)!))
            }
        }
    }
    
    static func uploadMajor(model:Major, completionHandler: @escaping (_ state:UIState)->Void){
        let path = "classes/\(model.institution.name!)/\(model.name!)/createdBy"
        
        ref.child(path).setValue(model.uid) { (err, _) in
            if(err == nil){
                completionHandler(.Success())
            }
            else{
                completionHandler(.Failure(err.debugDescription))
            }
        }
    }
    
    static func uploadMajor(model:MajorWithYear, uid:String, completionHandler: @escaping (_ state:UIState)->Void){
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
    
    
    private static func updateStudentEnrollList(uid:String,to model:ClassAndMajorWithYearProtocol,completionHandler: @escaping (_ uiState:UIState) -> Void){
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
}
