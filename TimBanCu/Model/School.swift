//
//  Schools.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class School{
    //var imageUrl:String
    var name:String!
    var address:String!
    var type:String!
    var uid:String!
    
    /*init(name:String,address:String,imageUrl:String,uid:String,type:String){
        self.name = name
        self.address = address
        self.imageUrl = imageUrl
        self.uid = uid
        self.type = type
    }*/
    
    init(name:String,address:String,type:String,uid:String){
        self.name = name
        self.address = address
        self.type = type
        self.uid = uid
    }
    
    func getModelAsDictionary() -> [String:Any]{
        let dic:[String:Any] = ["type":type,"address":address,"uid":uid]
        return dic
    }
    
    func writeToDatabase(completionHandler: @escaping (Error?,DatabaseReference)->Void){
        
        Database.database().reference().child("schools").child(name).setValue(getModelAsDictionary(), withCompletionBlock: completionHandler)
    }
}
