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
    var uid: String!
    var institution: Institution!
    private let classNameString:String
    private let classNumberString:String
    
    init(institution:InstitutionFull, classNumber:String,className:String, uid:String){
        self.classNameString = className
        self.uid = uid
        self.institution = institution
        self.classNumberString = classNumber
    }
    
    init(institution:Institution, classNumber:String,className:String, uid:String){
        self.classNameString = className
        self.uid = uid
        self.institution = institution
        self.classNumberString = classNumber
    }
    
    init(classs:Class){
        self.classNameString = classs.getClassName()
        self.uid = classs.uid
        self.institution = classs.institution
        self.classNumberString = classs.getClassNumber()
    }
    
    func uploadToFirebase(completionHandler: @escaping (_ state:UIState)->Void){
        Database.database().reference().child(firebaseUploadPath()).setValue(uid) { (err, _) in
            if(err == nil){
                completionHandler(.Success())
            }
            else{
                completionHandler(.Failure(err.debugDescription))
            }
        }
    }
    
    func firebaseUploadPath()->String{
        return "classes/\(institution.name!)/\(getClassNumber)/\(getClassName)/createdBy"
    }
    
    func getClassName()->String{
        return classNameString
    }
    
    func getClassNumber()->String{
        return classNumberString
    }
    
    static func nameExist(name:String, classes:[Class])->Bool{
        let className = name.uppercased()
        for classN in classes{
            if(className == classN.getClassName().uppercased()){
                return true
            }
        }
        return false
    }
    
    func classYearExist(year: String, completionHandler: @escaping (Bool) -> Void) {
        Database.database().reference().child(firebaseClassYearPath(year: year)).observeSingleEvent(of: .value) { (snapshot) in
            
            let classValue = (snapshot as! DataSnapshot).value
            
            if(classValue == nil){
                completionHandler(false)
            }
            else{
                completionHandler(true)
            }
        }
    }
    
    func firebaseClassYearPath(year:String)->String{
        return "classes/\(institution.name!)/\(getClassNumber())/\(getClassName())/\(year)"
    }
    
    static func fetchAllClass(institution:InstitutionFull,classNumber:String,completionHandler: @escaping (UIState, [Class]) -> ()){
        Database.database().reference().child(firebaseFetchPath(institutionName: institution.name, classNumber: classNumber)).observeSingleEvent(of: .value, with: { (snapshot) in
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
    
    static func firebaseFetchPath(institutionName:String, classNumber:String)->String{
        return "classes/\(institutionName)/\(classNumber)"
    }
    
    func copy() -> ClassAndMajorProtocol {
        return Class(classs: self)
    }
}
