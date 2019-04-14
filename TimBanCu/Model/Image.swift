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
    var image:UIImage?
    var dkasset: DKAsset?
    var uid:String!
    
    init(image:UIImage, uid:String){
        self.image = image
        self.uid = uid
    }
    init(image:UIImage, imageName:String,uid:String){
        self.image = image
        self.imageName = imageName
        self.uid = uid
    }
    init(image:UIImage, year:String?,uid:String){
        self.image = image
        self.year = year
        if(year == "-1"){
            self.year = nil
        }
        self.uid = uid
    }
    init(image:UIImage, year:String?,imageName:String,uid:String){
        self.image = image
        self.year = year
        self.imageName = imageName
        if(year == "-1"){
            self.year = nil
        }
        self.uid = uid
    }
    init(year:String?,imageName:String,uid:String){
        self.year = year
        self.imageName = imageName
        if(year == "-1"){
            self.year = nil
        }
        self.uid = uid
    }
}


