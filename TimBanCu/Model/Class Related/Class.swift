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
    let classNameString:String
    let classNumberString:String
    
    /*init(institution:InstitutionFull, classNumber:String,className:String, uid:String){
        self.classNameString = className
        self.uid = uid
        self.institution = institution
        self.classNumberString = classNumber
    }*/
    
    init(institution:Institution, classNumber:String,className:String, uid:String){
        self.classNameString = className
        self.uid = uid
        self.institution = institution
        self.classNumberString = classNumber
    }
    
    init(classs:Class){
        self.classNameString = classs.classNameString
        self.uid = classs.uid
        self.institution = classs.institution
        self.classNumberString = classs.classNumberString
    }
    
    static func nameExist(name:String, classes:[Class])->Bool{
        let className = name.uppercased()
        for classN in classes{
            if(className == classN.classNameString.uppercased()){
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
    
    func copy() -> ClassAndMajorProtocol {
        return Class(classs: self)
    }
}
