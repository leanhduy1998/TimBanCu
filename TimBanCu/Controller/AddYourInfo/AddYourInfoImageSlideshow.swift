//
//  AddYourInfoImageSlideshow.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/25/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit
import ImageSlideshow

extension AddYourInfoViewController{
    func setupImageSlideShow(){
        let pageIndicator = UIPageControl()
        imageSlideShow.pageIndicator = pageIndicator
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        imageSlideShow.addGestureRecognizer(gestureRecognizer)
        
        
        imageSlideShow.currentPageChanged = { page in
            DispatchQueue.main.async {
                self.reloadYearLabel(page: page)
            }
        }
    }
    
    @objc func didTap() {
        selectedImage = userImages[imageSlideShow.currentPage]
        
        if(yearOfUserImage[selectedImage] == nil){
            present(addImageYearAlert, animated: true, completion: nil)
        }
        
        performSegue(withIdentifier: "AddYourInfoToImageDetail", sender: self)
    }
    
    
    
    func reloadImageSlideShow(){
        if(userImages.count==0){
            imageSlideShow.setImageInputs([
                ImageSource(image: #imageLiteral(resourceName: "profile"))
                ])
        }
        else{
            var imageSources = [ImageSource]()
            
            for image in userImages{
                imageSources.append(ImageSource(image: image))
            }
            
            imageSlideShow.setImageInputs(imageSources)
            
            self.imageSlideShow.setCurrentPage(userImages.count-1, animated: true)
        }
    }
    
    func animateImageSlideShow(count:Int){
        if(count <= (userImages.count-1)){
            let deadlineTime = DispatchTime.now() + .milliseconds(count*1000)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.imageSlideShow.setCurrentPage(count, animated: true)
                self.animateImageSlideShow(count: count + 1)
            }
        }
        else{
            self.imageSlideShow.setCurrentPage(0, animated: true)
        }
    }
}
