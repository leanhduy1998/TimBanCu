//
//  ImagePicker.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/14/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import DKImagePickerController

class ImagePicker:DKImagePickerController{
    init(viewcontroller:UIViewController){
        super.init(nibName: nil, bundle: nil)
      //  super.init(rootViewController: viewcontroller)
        
        self.showsCancelButton = true
        self.assetType = .allPhotos
        self.sourceType = .photo
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
