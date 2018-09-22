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
    
    var currentImages  = [Image]()
    
    let pickerController = DKImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        var fetchCount = 0
        
        pickerController.showsCancelButton = true
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            if(assets.count == 0){
                self.performSegue(withIdentifier: "unwindToAddYourInfoControllerWithSegue", sender: self)
                self.pickerController.dismiss()
            }
            
            
            let currentTime = Int(Date().timeIntervalSince1970.binade)
            
            for asset in assets{
                asset.fetchOriginalImage(completeBlock: { (uiimage, something) in
                    
                    let imageName = "\((currentTime + fetchCount))"
                    let image = Image(image: uiimage!, imageName: imageName)
                    
                    self.currentImages.append(image)
                    
                    fetchCount = fetchCount + 1
                    
                    if(fetchCount == assets.count){
                        //self.pickerController.dismiss()
                        self.performSegue(withIdentifier: "unwindToAddYourInfoControllerWithSegue", sender: self)
                        self.pickerController.done()
                        
                    }
                })
            }
        }
        //pickerController.acti
      //  pickerController.setSelectedAssets(assets: selectedAssets)
       // pickerController.select(assets: selectedAssets)

  
        pickerController.assetType = .allPhotos
        pickerController.sourceType = .photo
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddYourInfoViewController{
            destination.userImages = currentImages
        }
    }
    

}


