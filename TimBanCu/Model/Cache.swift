//
//  Cache.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/19/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class Cache{
    private static let cache = NSCache<AnyObject, AnyObject>()
    
    static func getImageFromCache(imageName:String) -> UIImage?{
        let cacheKey = "\(imageName) \(CurrentUser.getUid())"
        let image = cache.object(forKey: cacheKey as AnyObject) as? UIImage
        
        return image
    }
    
    static func addImageToCache(imageName:String,image:UIImage){
        let cacheKey = "\(imageName) \(CurrentUser.getUid())"
        cache.setObject(image, forKey: cacheKey as AnyObject)
    }
}


