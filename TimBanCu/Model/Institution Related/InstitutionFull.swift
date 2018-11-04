//
//  Schools.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class InstitutionFull:Institution{
    //var imageUrl:String
    var type:String!
    var addByUid:String!
    var address:String?
    
    
    init(name:String,address:String?,type:String,addByUid:String){
        super.init(name: name)
        self.type = type
        self.addByUid = addByUid
        self.address = address
    }
    
    init(name:String,type:String,addByUid:String){
        super.init(name: name)
        self.type = type
        self.addByUid = addByUid
    }
    
    private func getModelAsDictionary() -> [String:Any]{
        var dic:[String:Any] = ["type":type,"uid":addByUid]
        if(address != nil){
            dic["address"] = address!
        }
        return dic
    }
    
    static func getInstitutionsFrom(snapshot:DataSnapshot,educationLevel:EducationLevel)->[InstitutionFull]{
    
        var institutions = [InstitutionFull]()
        
        for snap in snapshot.children {
            institutions.append(getInstitution(key: (snap as! DataSnapshot).key, value: (snap as! DataSnapshot).value as! [String:Any], educationLevel: educationLevel))
        }
        
        return institutions
    }
    
    static func getInstitution(key:String,value:[String:Any], educationLevel:EducationLevel)->InstitutionFull{
        let name = key
        let address = value["address"] as? String
        let uid = value["uid"] as? String
        
        let institution = InstitutionFull(name: name, address: address, type: educationLevel.getString(), addByUid: uid!)
        
        return institution
    }
    
    func writeToDatabase(completionHandler: @escaping (Error?,DatabaseReference)->Void){
        Database.database().reference().child(firebasePath()).setValue(getModelAsDictionary(), withCompletionBlock: completionHandler)
    }
    
    func firebasePath()->String{
        return "schools/\(name!)"
    }
}


