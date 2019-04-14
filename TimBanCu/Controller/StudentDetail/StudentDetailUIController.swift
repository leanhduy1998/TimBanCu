//
//  StudentDetailUIController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/16/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit
import ImageSlideshow

class StudentDetailUIController{
    private var viewcontroller:StudentDetailViewController!
    private var nameLabel:UILabel!
    private var birthYearLabel:UILabel!
    private var phoneLabel:UILabel!
    private var emailLabel:UILabel!
    private var yearLabel:UILabel!
    
    private var imageSlideshow: ImageSlideshow!
    private var student:Student!
    
    private let generalErrorAlert = InfoAlert(title: "Lỗi Kết Nối", message: "", alertType: .Error)
    
    
    func update(newState: UIState) {
        switch(newState) {
        case (.Loading): showLoading()
        case (.Success()):
            stopLoading()
            reloadimageSlideshow()
            break
        case (.Failure(let errStr)):
            stopLoading()
            
            generalErrorAlert.changeMessage(message: errStr)
            generalErrorAlert.show(viewcontroller: viewcontroller)
            break
        default:
            break
        }
    }
    
    private func showLoading(){
        //TODO
    }
    private func stopLoading(){
        //TODO
    }
    
    
    
    init(viewcontroller:StudentDetailViewController){
        self.viewcontroller = viewcontroller
        self.nameLabel = viewcontroller.nameLabel
        self.imageSlideshow = viewcontroller.imageSlideshow
        self.student = viewcontroller.student
        self.birthYearLabel = viewcontroller.birthYearLabel
        self.phoneLabel = viewcontroller.phoneLabel
        self.emailLabel = viewcontroller.emailLabel
        self.yearLabel = viewcontroller.yearLabel
        
        setUpHeroId()
        setUpStudentDetailsUI()
        setupimageSlideshow()
        reloadYearLabel(page: 0)
    }
    
    fileprivate func setUpHeroId() {
        nameLabel.hero.isEnabled = true
        imageSlideshow.hero.isEnabled = true
        nameLabel.hero.id = "\(String(describing: student.fullName))"
        imageSlideshow.hero.id = "\(String(describing: student.fullName))image"
        nameLabel!.hero.modifiers = [.arc]
        imageSlideshow.hero.modifiers = [.arc]
    }
    
    fileprivate func setUpStudentDetailsUI() {
        nameLabel.text = student.fullName
        birthYearLabel.text = student.birthYear
        
        if(student.phoneNumber == nil){
            phoneLabel.text = "Số Điện Thoại Này Không Được Công Khai."
        }
        else{
            phoneLabel.text = student.phoneNumber
        }
        
        if(student.email == nil){
            emailLabel.text = "Địa Chỉ Email Này Không Được Công Khai."
        }
        else{
            emailLabel.text = student.email
        }
    }
    
    fileprivate func reloadYearLabel(page:Int){
        if(page >= viewcontroller.userImages.count){
            yearLabel.text = "Năm ?"
            return
        }
        
        if(viewcontroller.userImages[page].year == nil){
            yearLabel.text = "Năm ?"
        }
        else{
            yearLabel.text = viewcontroller.userImages[page].year
        }
        
        viewcontroller.view.layoutIfNeeded()
    }
}

// Image Slide Show
extension StudentDetailUIController{
    fileprivate func setupimageSlideshow(){
        let pageIndicator = UIPageControl()
        imageSlideshow.pageIndicator = pageIndicator
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        imageSlideshow.addGestureRecognizer(gestureRecognizer)
        
        
        imageSlideshow.currentPageChanged = { page in
            self.reloadYearLabel(page: page)
        }
    }
    
    fileprivate func reloadimageSlideshow(){
        var imageSources = [ImageSource]()
        
        for image in viewcontroller.userImages{
            imageSources.append(ImageSource(image: image.image!))
        }
        
        imageSlideshow.setImageInputs(imageSources)
        
        self.imageSlideshow.setCurrentPage(0, animated: true)
    }
    
    @objc fileprivate func didTap(){
        viewcontroller.selectedImage = viewcontroller.userImages[imageSlideshow.currentPage]
        viewcontroller.performSegue(withIdentifier: "StudentDetailToUserImageSegue", sender: viewcontroller)
    }
}
