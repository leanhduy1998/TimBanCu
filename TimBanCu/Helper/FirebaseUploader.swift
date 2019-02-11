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
    
    static func upload(institution:InstitutionFull,completionHandler: @escaping (Error?,DatabaseReference)->Void){
        
        var dic:[String:Any] = ["type":institution.type,"uid":institution.addByUid]
        if(institution.address != nil){
            dic["address"] = institution.address
        }
        ref.child("schools/\(institution.name!)").setValue(dic, withCompletionBlock: completionHandler)
    }
    
    static func upload(classs:Class,completionHandler: @escaping (_ state:UIState)->Void){
        
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
    
    static func upload(uid:String,model:ClassWithYear,completionHandler: @escaping (UIState) -> Void) {
        
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
    
    static func upload(student:Student, to classs:ClassWithYear,completionHandler: @escaping (_ uiState:UIState) -> Void) {
        
        let path = "classes/\(classs.institution.name!)/\(classs.classNumberString)/\(classs.classNameString)/\(classs.year)"
        ref.child(path).child(student.uid).setValue(student.fullName) { (err, _) in
            if(err == nil){
                completionHandler(.Success())
            }
            else{
                completionHandler(.Failure((err?.localizedDescription)!))
            }
        }
    }
    
    static func upload(student:Student, to major:MajorWithYear,completionHandler: @escaping (_ uiState:UIState) -> Void) {
        
        let path = "classes/\(major.institution.name!)/\(major.name!)/\(major.year)"
        ref.child(path).child(student.uid).setValue(student.fullName) { (err, _) in
            if(err == nil){
                completionHandler(.Success())
            }
            else{
                completionHandler(.Failure((err?.localizedDescription)!))
            }
        }
    }
    
    static func upload(model:Major, completionHandler: @escaping (_ state:UIState)->Void){
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
    
    static func upload(model:MajorWithYear, uid:String, completionHandler: @escaping (_ state:UIState)->Void){
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
}
