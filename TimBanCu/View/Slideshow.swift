//
//  ImageSlideShow.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/11/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import ImageSlideshow

class Slideshow:ImageSlideshow{
    
    private var userImages:[Image]!
    
    var didTapOnImage: (Int)->()
    
    
    func setup(userImages:[Image], didTapOnImage: @escaping (Int)->(), currentPageChanged:@escaping (Int)->()){
        
        self.didTapOnImage = didTapOnImage
        self.userImages = userImages
        
        let pageIndicator = UIPageControl()
        self.pageIndicator = pageIndicator
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        self.addGestureRecognizer(gestureRecognizer)
        
        self.currentPageChanged = { page in
            currentPageChanged(page)
        }
        
        setUserImages(images: userImages)
        
        reloadImageSlideShow()
    }
    
    func setUserImages(images:[Image]){
        userImages = images
        userImages.append(Image(image: #imageLiteral(resourceName: "addImage")))
    }
    
    func reloadImageSlideShow(){
        var imageSources = [ImageSource]()
        
        for x in 0...(userImages.count-1){
            imageSources.append(ImageSource(image: userImages[x].image!))
        }
        
        self.setImageInputs(imageSources)
        
        // set slideshow to last image, which is the add new image button
        self.setCurrentPage(images.count-1, animated: true)
        
        self.reloadInputViews()
    }
    
    @objc private func didTap() {
        didTapOnImage(self.currentPage)
    }
    
    func animateImageSlideShow(){
        animateImageSlideShow(count: 0)
    }
    
    private func animateImageSlideShow(count:Int){
        // if slideshow is still showing users' images
        if(count < userImages.count){
            let deadlineTime = DispatchTime.now() + .milliseconds(count*500)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.setCurrentPage(count, animated: true)
                self.animateImageSlideShow(count: count + 1)
            }
        }
            
        // slow down when slideshow shows add new photo button (as image) to let user know
        else if(count == userImages.count){
            let deadlineTime = DispatchTime.now() + .milliseconds(count*500)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.setCurrentPage(count, animated: true)
                self.animateImageSlideShow(count: count + 1)
            }
        }
            
        // go back to the front image
        else{
            self.setCurrentPage(0, animated: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.didTapOnImage = {_ in }
        super.init(coder: aDecoder)
    }
}
