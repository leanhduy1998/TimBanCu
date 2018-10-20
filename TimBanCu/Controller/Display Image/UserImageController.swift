//
//  UserImageController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/17/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class UserImageController{
    private var viewcontroller:UserImageViewController!
    private var userImages:[Image]!
    private var image:Image!
    
    
    var ref = Database.database().reference()
    var storage = Storage.storage().reference()
    
    init(viewcontroller:UserImageViewController){
        self.viewcontroller = viewcontroller
        self.userImages = viewcontroller.userImages
        self.image = viewcontroller.image
    }
    
    func removeImage(completionHandler: @escaping (_ uiState:UIState)->()){
        let imageName = userImages[getImageIndex()].imageName
        userImages.remove(at: getImageIndex())
        
        if(viewcontroller.previousClassIsStudentDetailViewController()){
            ref.child("publicUserProfile/\(CurrentUser.getUid())/images/\(imageName!)").removeValue { (dbErr, _) in
                
                if(dbErr != nil){
                    completionHandler(.Failure(dbErr.debugDescription))
                }
                else{
                    self.storage.child("users/\(CurrentUser.getUid())/\(imageName!)").delete(completion: { (storageErr) in
                    
                        if(storageErr != nil){
                            completionHandler(.Failure(storageErr.debugDescription))
                        }
                        else{
                            completionHandler(.Success())
                        }
                    })
                }
            }
        }
    }
    
    
    
    private func getImageIndex()->Int{
        var index = 0
        for i in userImages{
            if(i.imageName == image.imageName){
                break
            }
            index += 1
        }
        return index
    }
}
