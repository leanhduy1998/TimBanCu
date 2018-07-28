//
//  ChatImage.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/28/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit
import JSQMessagesViewController
import FirebaseStorage

extension ChatViewController{
    func fetchImageDataAtURL(_ photoURL: String, forMediaItem mediaItem: JSQPhotoMediaItem, clearsPhotoMessageMapOnSuccessForKey key: String?) {
        
        let storageRef = Storage.storage().reference(forURL: photoURL)
        
        storageRef.getData(maxSize: INT64_MAX){ (data, error) in
            if let error = error {
                print("Error downloading image data: \(error)")
                return
            }
            
            mediaItem.image = UIImage.init(data: data!)
            self.collectionView.reloadData()
            
            guard key != nil else {
                return
            }
            self.photoMessageMap.removeValue(forKey: key!)
        }
    }
    
    func setImageURL(_ url: String, forPhotoMessageWithKey key: String) {
        let itemRef = messageRef.child(key)
        itemRef.updateChildValues(["photoURL": url])
    }
}
