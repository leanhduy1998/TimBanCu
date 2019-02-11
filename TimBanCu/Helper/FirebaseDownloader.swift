//
//  FirebaseDownloader.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/10/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import UIKit

class FirebaseDownloader{
    static let shared = FirebaseDownloader()
    private let storageRef = Storage.storage().reference()
    private let snapshotDownloader:FirebaseSnapshotDownloader
    private let snapshotParser:FirebaseSnapshotParser
    private let storageDownloader:FirebaseStorageDownloader
    
    init(){
        snapshotDownloader = FirebaseSnapshotDownloader(caller: self)
        snapshotParser = FirebaseSnapshotParser(caller: self)
        storageDownloader = FirebaseStorageDownloader(caller: self)
    }
    
    func getStudent(with uid:String, completionHandler: @escaping (_ student:Student?)->Void){
        snapshotDownloader.getStudent(with: uid) { (publicSS, privateSS, state) in
            
            switch(state){
            case .Success():
                let student = snapshotParser.getStudent(uid: uid, publicSS: publicSS!, privateSS: privateSS!)
                completionHandler(student)
            default:
                completionHandler(nil)
            }
        }
    }
    
    private var imageDownloaded = 0
    private var totalImages = 0
    
    func getImages(student:Student, completion:@escaping ()->Void){
        imageDownloaded = 0
        totalImages = student.images.count
        
        for image in student.images{
            if(image.image == nil){
                let imageFromCache = Cache.getImageFromCache(imageName: image.imageName)
                
                if(imageFromCache != nil){
                    image.image = imageFromCache
                    updateImageCounter(completion: completion)
                }
                else{
                    let path = "users/\(student.uid!)/\(image.imageName!)"

                    storageDownloader.getImage(from: path) { (uiimage) in
                        image.image = uiimage
                        self.updateImageCounter(completion: completion)
                    }
                }
            }
            else{
                updateImageCounter(completion: completion)
            }
        }
    }
    
    private func updateImageCounter(completion:()->Void){
        imageDownloaded += 1
        if imageDownloaded == totalImages{
            completion()
        }
    }
}
