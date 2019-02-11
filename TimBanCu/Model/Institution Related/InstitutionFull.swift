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
}


