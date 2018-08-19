//
//  AddImagesViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/28/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import DKImagePickerController
import Photos

class AddImagesViewController: UIViewController {
    
    var currentImages  = [UIImage]()
    
    let pickerController = DKImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var fetchCount = 0
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            if(assets.count == 0){
                self.performSegue(withIdentifier: "unwindToAddYourInfoControllerWithSegue", sender: self)
                self.pickerController.dismiss()
            }
            
            for asset in assets{
                
                asset.fetchOriginalImage(completeBlock: { (image, something) in
                    
                    if(self.currentImages.count == 1){
                        self.currentImages.insert(image!, at: 0)
                    }
                    else{
                        self.currentImages.insert(image!, at: self.currentImages.count-2)
                    }
                    
                    fetchCount = fetchCount + 1
                    
                    if(fetchCount == assets.count){
                        self.performSegue(withIdentifier: "unwindToAddYourInfoControllerWithSegue", sender: self)
                        self.pickerController.dismiss()
                    }
                })
            }
            
        }
        pickerController.assetType = .allPhotos
        pickerController.sourceType = .photo
        self.present(pickerController, animated: true) {}
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddYourInfoViewController{
            destination.userImages = currentImages
        }
    }
    

}
