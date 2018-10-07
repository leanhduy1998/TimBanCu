//
//  FirebasePath.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/13/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseHelper{
    private static let ref = Database.database().reference()
    
  
    static func writeToDatabase(model:Any,completionHandler: @escaping (_ err:Error?,_ ref:DatabaseReference) -> Void){
        if let model = model as? ClassDetail{
            ref.child("classes/\(model.schoolName!)/\(model.classNumber!)/\(model.className!)/\(model.year!)").setValue(model.getUidAsDictionary(), withCompletionBlock: completionHandler)
        }
        if let model = model as? MajorDetail{
            ref.child("classes/\(model.schoolName!)/\(model.majorName!)/\(model.year!)").setValue(model.getModelAsDictionary(), withCompletionBlock: completionHandler)
        }
        if let model = model as? School{
            ref.child("schools").child(model.name).setValue(model.getModelAsDictionary(), withCompletionBlock: completionHandler)
        }
    }
}
