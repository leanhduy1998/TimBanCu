//
//  ChatUIController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/21/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class ChatUIController:NSObject{
    private var viewcontroller:ChatViewController!
    
    fileprivate let imagePickerController = UIImagePickerController()
    
    fileprivate var didFinishPickingImage: (UIImage)->()
    
    init(viewcontroller:ChatViewController,didFinishPickingImage: @escaping (UIImage)->()){
        self.didFinishPickingImage = didFinishPickingImage
        super.init()
        
        self.viewcontroller = viewcontroller
        
        setupChatCollectionView()
        setupImagePickerController()
    }
    
    func showImagePickerController(){
        viewcontroller.present(imagePickerController, animated: true, completion: nil)
    }
    
    fileprivate func setupChatCollectionView(){
        viewcontroller.collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        viewcontroller.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    }
}

// imagePicker
extension ChatUIController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    fileprivate func setupImagePickerController(){
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePickerController.allowsEditing = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion:nil)
        
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        didFinishPickingImage(image!)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
}
