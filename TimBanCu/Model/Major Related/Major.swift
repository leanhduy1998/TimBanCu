//
//  Major.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/24/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Major:ClassAndMajorProtocol{
    var institution: Institution!
    var uid:String!
    var name:String!
    
    /*init(institution: InstitutionFull,uid:String,majorName:String){
        self.institution = institution
        self.uid = uid
        self.majorName = majorName
    }*/
    
    init(institution: Institution,uid:String,majorName:String){
        self.institution = institution
        self.uid = uid
        self.name = majorName
    }
    
    init(major:Major){
        self.institution = major.institution
        self.uid = major.uid
        self.name = major.name
    }
    
    
    
    func classYearExist(year: String, completionHandler: @escaping (Bool) -> Void) {
        Database.database().reference().child(firebaseClassYearPath(year: year)).observeSingleEvent(of: .value) { (snapshot) in
            
            let value = (snapshot as! DataSnapshot).value as? [String:String]
            
            if(value == nil){
                completionHandler(false)
            }
            else{
                completionHandler(true)
            }
        }
    }
    
    func firebaseClassYearPath(year:String)->String{
        return "classes/\(institution.name!)/\(name!)/\(year)"
    }
    
    func copy() -> ClassAndMajorProtocol {
        return Major(major: self)
    }
    
    
}
