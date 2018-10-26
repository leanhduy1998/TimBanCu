//
//  Class.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/24/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Class:ClassAndMajorProtocol{
    internal var uid: String!
    internal var institution: Institution!
    internal let className:String
    internal let classNumber:String
    
    init(institution:InstitutionFull, classNumber:String,className:String, uid:String){
        self.className = className
        self.uid = uid
        self.institution = institution
        self.classNumber = classNumber
    }
    
    init(institution:Institution, classNumber:String,className:String, uid:String){
        self.className = className
        self.uid = uid
        self.institution = institution
        self.classNumber = classNumber
    }
    
    init(classs:Class){
        self.className = classs.className
        self.uid = classs.uid
        self.institution = classs.institution
        self.classNumber = classs.classNumber
    }
    
    func uploadToFirebase(completionHandler: @escaping (_ state:UIState)->Void){
        Database.database().reference().child("classes/\(institution.name!)/\(classNumber)/\(className)/createdBy").setValue(uid) { (err, _) in
            if(err == nil){
                completionHandler(.Success())
            }
            else{
                completionHandler(.Failure(err.debugDescription))
            }
        }
    }
    
    func getName()->String{
        return className
    }
    
    static func nameExist(name:String, classes:[Class])->Bool{
        let className = name.uppercased()
        for classN in classes{
            if(className == classN.getName()){
                return true
            }
        }
        return false
    }
    
    func classYearExist(year: String, completionHandler: @escaping (Bool) -> Void) {
        Database.database().reference().child("classes/\(institution.name!)/\(classNumber)/\(className)/\(year)").observeSingleEvent(of: .value) { (snapshot) in
            
            let classValue = (snapshot as! DataSnapshot).value
            
            if(classValue == nil){
                completionHandler(false)
            }
            else{
                completionHandler(true)
            }
        }
    }
    
    static func fetchAllClass(institution:InstitutionFull,classNumber:String,completionHandler: @escaping (UIState, [Class]) -> ()){
        Database.database().reference().child("classes/\(institution.name!)/\(classNumber)").observeSingleEvent(of: .value, with: { (snapshot) in
            var classes = [Class]()
            
            for snap in snapshot.children{
                let className = (snap as! DataSnapshot).key
                
                let value = (snap as! DataSnapshot).value as! [String:Any]
                let createdByUid = value["createdBy"] as! String
                
                let classN = Class(institution: institution, classNumber: classNumber, className: className, uid: createdByUid)
                classes.append(classN)
                
            }
            
            completionHandler(.Success(),classes)
        }) { (er) in
            completionHandler(.Failure(er.localizedDescription),[Class]())
        }
    }
    
    func copy() -> ClassAndMajorProtocol {
        return Class(classs: self)
    }
}
