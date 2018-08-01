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
    
    override func viewDidLayoutSubviews() {
        
        var fetchCount = 0
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            for asset in assets{
                asset.fetchOriginalImage(true, completeBlock: { (image, something) in
                    
                    if(self.currentImages.count == 1){
                        self.currentImages.insert(image!, at: 0)
                    }
                    else{
                        self.currentImages.insert(image!, at: self.currentImages.count-2)
                    }
                    
                    fetchCount = fetchCount + 1
                    
                    if(fetchCount == assets.count){
                    
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "unwindToAddYourInfoControllerWithSegue", sender: self)
                        }
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
