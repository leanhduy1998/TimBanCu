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
    var address:String!
    
    
    init(name:String,address:String,type:String,addByUid:String){
        super.init(name: name)
        self.type = type
        self.addByUid = addByUid
        self.address = address
    }
    
    init(name:String,type:String,addByUid:String){
        super.init(name: name)
        self.type = type
        self.addByUid = addByUid
        self.address = "?"
    }
    
    func getModelAsDictionary() -> [String:Any]{
        let dic:[String:Any] = ["type":type,"address":address,"uid":addByUid]
        return dic
    }
    
    static func getInstitutionsFromFirebaseSnapshot(snapshot:DataSnapshot,educationLevel:EducationLevel)->[InstitutionFull]{
        var institutions = [InstitutionFull]()
        
        for snap in snapshot.children {
            let value = (snap as! DataSnapshot).value as? [String:Any]
            
            let name = (snap as! DataSnapshot).key
            let address = value!["address"] as? String
            let uid = value!["uid"] as? String
            
            let institution = InstitutionFull(name: name, address: address!, type: educationLevel.getString(), addByUid: uid!)
            
            institutions.append(institution)
        }
        
        return institutions
    }
    
    func writeToDatabase(completionHandler: @escaping (Error?,DatabaseReference)->Void){
        
        Database.database().reference().child("schools").child(name).setValue(getModelAsDictionary(), withCompletionBlock: completionHandler)
    }
}
