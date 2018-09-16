//
//  ImageWithName.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/11/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit
import DKImagePickerController

class Image{
    var imageName:String!
    var year:String?
    var image:UIImage!
    var dkasset: DKAsset?
    
    init(image:UIImage){
        self.image = image
    }
    init(image:UIImage, imageName:String){
        self.image = image
        self.imageName = imageName
    }
    init(image:UIImage, year:String){
        self.image = image
        self.year = year
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}
