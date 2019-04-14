//
//  FirebaseStorageDownloader.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/10/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseStorage

class FirebaseStorageDownloader{
        
    private let storageRef = Storage.storage().reference()
    
    func getImage(from path:String,completion: @escaping (UIImage?)->Void){

        storageRef.child(path).getData(maxSize: INT64_MAX) { (imageData, error) in
            if(error == nil){
                let image = UIImage(data: imageData!)
                completion(image)
            }
            else{
                completion(nil)
            }
        }
    }
}
