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
    
    static func getModelAsDic(model:Any) -> [String:Any]{
        if let model = model as? School{
            let dic:[String:Any] = ["type":model.type,"address":model.address,"uid":model.uid]
            return dic
        }
        else if let model = model as? ClassDetail{
            return ["uid":model.uid]
        }
        else if let model = model as? MajorDetail{
            return ["uid":model.uid]
        }
            
        // write test case that if uiimage is nil, error
        else if let model = model as? Student{
            var imageNameAndYear = [String:String]()
            for image in model.images{
                imageNameAndYear[image.imageName] = image.year
            }
            
            return ["fullName":model.fullName,"birthday":model.birthYear,"phoneNumber":model.phoneNumber,"email":model.email,"imageUrls":imageNameAndYear,"enrolledIn":model.enrolledIn]
        }
        
        return [:]
    }
    
    static func writeToDatabase(model:Any,completionHandler: @escaping (_ err:Error?,_ ref:DatabaseReference) -> Void){
        if let model = model as? ClassDetail{
            ref.child("classes/\(model.schoolName!)/\(model.classNumber!)/\(model.className!)/\(model.year!)").setValue(getModelAsDic(model: model), withCompletionBlock: completionHandler)
        }
        if let model = model as? MajorDetail{
            ref.child("classes/\(model.schoolName!)/\(model.majorName!)/\(model.year!)").setValue(getModelAsDic(model: model), withCompletionBlock: completionHandler)
        }
    }
}
