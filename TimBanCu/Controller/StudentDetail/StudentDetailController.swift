//
//  StudentDetailController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/19/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseStorage

class StudentDetailController{
    private var viewcontroller:StudentDetailViewController!
    private var student:Student!
    
    init(viewcontroller:StudentDetailViewController){
        self.viewcontroller = viewcontroller
        self.student = viewcontroller.student
    }
    
    func fetchStudentImages(completionHandler: @escaping (_ uiState:UIState) -> Void) {
        viewcontroller.userImages.removeAll()
        
        var count = 0
        
        for image in student.images{
            if(image.image == nil){
                if(Cache.getImageFromCache(imageName: image.imageName) != nil){
                    image.image = Cache.getImageFromCache(imageName: image.imageName)
                    viewcontroller.userImages.append(image)
                    count += 1
                }
                else{
                    Storage.storage().reference().child("users/\(student.uid!)/\(image.imageName!)").getData(maxSize: INT64_MAX) { [weak self] (imageData, error) in
                        
                        if(error == nil){
                            let uiimage = UIImage(data: imageData!)

                            let newImage = Image(image: uiimage!, year: image.year, imageName:image.imageName, uid:self!.student.uid)
                            self!.viewcontroller.userImages.append(newImage)
                            
                            count += 1
                            
                            if(count == self!.student.images.count){
                                completionHandler(.Success())
                            }
                        }
                        else{
                            completionHandler(.Failure(error.debugDescription))
                        }
                    }

                }
            }
            else{
                viewcontroller.userImages.append(image)
                count += 1
            }
            
            if(count == self.student.images.count){
                completionHandler(.Success())
            }
        }
    }
}
