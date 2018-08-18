//
//  ChatImagePicker.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/28/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion:nil)
        
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        let imageData = image?.jpeg(.medium)
        
        if(imageData == nil){
            return
        }
        
        let imageRef = storage.reference().child("messages").child(classDetail.schoolName).child(classDetail.classNumber).child(classDetail.className)
        
        
        if let key = sendPhotoMessage() {
            let path = "\(Int(Date.timeIntervalSinceReferenceDate * 1000)))"
            
            imageRef.child(path).putData(imageData!, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print("Error uploading photo: \(error?.localizedDescription)")
                    return
                }
                
                print()
                self.setImageURL(imageRef.child(path).description, forPhotoMessageWithKey: key)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
    
}
