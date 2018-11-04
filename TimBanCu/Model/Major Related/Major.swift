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
    var majorName:String!
    
    init(institution: InstitutionFull,uid:String,majorName:String){
        self.institution = institution
        self.uid = uid
        self.majorName = majorName
    }
    
    init(institution: Institution,uid:String,majorName:String){
        self.institution = institution
        self.uid = uid
        self.majorName = majorName
    }
    
    init(major:Major){
        self.institution = major.institution
        self.uid = major.uid
        self.majorName = major.majorName
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
        return "classes/\(institution.name!)/\(majorName!)/\(year)"
    }
    
    func uploadToFirebase(completionHandler: @escaping (_ state:UIState)->Void){
        Database.database().reference().child(firebaseCreatedByPath()).setValue(uid) { (err, _) in
            if(err == nil){
                completionHandler(.Success())
            }
            else{
                completionHandler(.Failure(err.debugDescription))
            }
        }
    }
    
    func firebaseCreatedByPath()->String{
        return "classes/\(institution.name!)/\(majorName!)/createdBy"
    }
    
    static func fetchAllMajor(institution:InstitutionFull,completionHandler: @escaping (UIState, [Major]) -> ()){
        Database.database().reference().child(firebaseFetchPath(institution: institution)).observeSingleEvent(of: .value, with: { (snapshot) in
            var majors = [Major]()
            
            for snap in snapshot.children{
                let majorName = (snap as! DataSnapshot).key
                
                let value = (snap as! DataSnapshot).value as! [String:Any]
                let createdByUid = value["createdBy"] as! String
                
                let major = Major(institution: institution, uid: createdByUid, majorName: majorName)
                
                majors.append(major)
            }
            
            completionHandler(.Success(),majors)
        }) { (er) in
            completionHandler(.Failure(er.localizedDescription),[Major]())
        }
    }
    
    static func firebaseFetchPath(institution:InstitutionFull)->String{
        return "classes/\(institution.name!)"
    }
    
    func copy() -> ClassAndMajorProtocol {
        return Major(major: self)
    }
    
    
}
