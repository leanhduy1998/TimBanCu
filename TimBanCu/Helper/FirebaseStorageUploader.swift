//
//  FirebaseStorageUploader.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/19/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseStorage
import UIKit

class FirebaseStorageUploader{
    private let storage = Storage.storage().reference()
    
    func uploadImagesToStorage(images:[Image], completionHandler: @escaping (_ err:String?) -> Void){
        
        var imageUploaded = 0
        
        for image in images{
            let name = image.imageName
            let imageRef = storage.child(firebaseStorageImageUploadPath(name: name!))
            
            let data = image.image?.jpeg(UIImage.JPEGQuality(rawValue: 0.5)!)
            
            let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    completionHandler(error.debugDescription)
                    return
                }
                imageUploaded = imageUploaded + 1
                
                if(imageUploaded == images.count){
                    completionHandler(nil)
                }
            }
        }
    }
    
    private func firebaseStorageImageUploadPath(name:String)->String{
        return "users/\(CurrentUser.getUid())/\(name)"
    }
}
