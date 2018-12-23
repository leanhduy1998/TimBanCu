//
//  AddYourInfoUIController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/30/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit
import DropDown
import DKImagePickerController

class AddYourInfoUIController{
    
    fileprivate weak var viewcontroller:AddYourInfoViewController!
    fileprivate var alerts:AddYourInfoAlerts!
    
    fileprivate var phonePrivacyDropDown = DropDown()
    fileprivate var emailPrivacyDropDown = DropDown()
    
    fileprivate var phonePrivacyDropDownBtn:UIButton!
    fileprivate var emailPrivacyDropDownBtn:UIButton!
    
    fileprivate var slideshow:Slideshow!
    fileprivate var yearLabel:UILabel!
    fileprivate var keyboardHelper:KeyboardHelper!
    fileprivate var pickerController:ImagePicker!
    
    fileprivate var slideshowDidTapOnImageAtIndex:IndexOfImageClosure!
    fileprivate var imagePickerDidSelectAssets:ImageAssetSelectionClosure!
    
    fileprivate var fullNameTF:UITextField!
    fileprivate var birthYearTF:UITextField!
    fileprivate var phoneTF:UITextField!
    fileprivate var emailTF:UITextField!
    
    fileprivate var loadingAnimation:LoadingAnimation!
    
    init(viewcontroller:AddYourInfoViewController, slideshowDidTapOnImageAtIndex:@escaping (Int)->(), imagePickerDidSelectAssets:@escaping ([DKAsset])->()){
        self.viewcontroller = viewcontroller
        self.yearLabel = viewcontroller.yearLabel
        self.phonePrivacyDropDownBtn = viewcontroller.phonePrivacyDropDownBtn
        self.emailPrivacyDropDownBtn = viewcontroller.emailPrivacyDropDownBtn
        self.slideshow = viewcontroller.imageSlideShow
        self.slideshowDidTapOnImageAtIndex = slideshowDidTapOnImageAtIndex
        self.imagePickerDidSelectAssets = imagePickerDidSelectAssets
        
        self.fullNameTF = viewcontroller.fullNameTF
        self.birthYearTF = viewcontroller.birthYearTF
        self.phoneTF = viewcontroller.phoneTF
        self.emailTF = viewcontroller.emailTF
        
        setupAlerts()
        setupPrivacyDropDowns()
        setupSlideShow()
        setupKeyboard()
        setupImagePicker()
        
        observeTextFields()
        updateAddInfoBtnStatus()
        
        setupLoadingAnimation()
    }
    
    func viewDidLayoutSubview(){
        self.phonePrivacyDropDown.anchorView = phonePrivacyDropDownBtn
        self.emailPrivacyDropDown.anchorView = emailPrivacyDropDownBtn
    }
    
    fileprivate func reloadYearLabel(page:Int){
        DispatchQueue.main.async { [weak self] in
            if(page > self!.viewcontroller.userImages.count-1){
                self!.yearLabel.isHidden = true
            }
            else{
                self!.yearLabel.isHidden = false
                
                if(self!.viewcontroller.userImages[page].year == nil){
                    self!.yearLabel.text = "Năm ?"
                }
                else{
                    self!.yearLabel.text = "\(self!.viewcontroller.userImages[page].year!)"
                }
            }
            self!.viewcontroller.view.layoutIfNeeded()
        }
    }
}

// MARK: TextField
extension AddYourInfoUIController{
    private func observeTextFields(){
        fullNameTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        birthYearTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateAddInfoBtnStatus()
    }
    
    private func updateAddInfoBtnStatus(){
        if((fullNameTF.text?.isEmpty)! || (birthYearTF.text?.isEmpty)! ||
            (phoneTF.text?.isEmpty)! || (emailTF.text?.isEmpty)!){
            
            viewcontroller.addInfoBtn.isEnabled = false
            viewcontroller.addInfoBtn.setTitleColor(UIColor.gray, for: .normal)
        }
        else{
            viewcontroller.addInfoBtn.isEnabled = true
            viewcontroller.addInfoBtn.setTitleColor(Constants.AppColor.primaryColor, for: .normal)
        }
    }
}

// MARK:Image Picker
extension AddYourInfoUIController{
    fileprivate func setupImagePicker(){
        pickerController = ImagePicker(viewcontroller: viewcontroller)
        pickerController.didSelectAssets = imagePickerDidSelectAssets
    }
    
    func showPickerController(){
        viewcontroller.present(pickerController, animated: true, completion: nil)
    }
    
    func hidePickerController(){
        pickerController.done()
    }
}

// MARK:SlideShow

extension AddYourInfoUIController{
    fileprivate func setupSlideShow(){
        slideshow.setup(userImages: viewcontroller.userImages, didTapOnImage: slideshowDidTapOnImageAtIndex) { [weak self] (page) in
            
            self!.reloadYearLabel(page: page)
            
            // if the last image is the add new photo btn
            if(page == self!.viewcontroller.userImages.count-1){
                self!.yearLabel.isHidden = true
            }
                // else, show images'years
            else{
                self!.yearLabel.isHidden = false
            }
        }
        
        slideshow.reloadImageSlideShow()
    }
    func animateSlideShow(){
        slideshow.animateImageSlideShow()
    }
    func reloadSlideShow(){
        slideshow.setUserImages(images: viewcontroller.userImages)
        slideshow.reloadImageSlideShow()
    }
}

// MARK:DropDown
extension AddYourInfoUIController{
    fileprivate func setupPrivacyDropDowns(){
        phonePrivacyDropDown.dataSource = ["Công Khai", "Chỉ Riêng Tôi"]
        emailPrivacyDropDown.dataSource = ["Công Khai", "Chỉ Riêng Tôi"]
        
        phonePrivacyDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.phonePrivacyDropDownBtn.setTitle(item, for: .normal)
        }
        emailPrivacyDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.emailPrivacyDropDownBtn.setTitle(item, for: .normal)
        }
    }
    func showPhonePrivacyDownDown(){
        phonePrivacyDropDown.show()
    }
    func showEmailPrivacyDownDown(){
        emailPrivacyDropDown.show()
    }
}

// MARK:Alerts
extension AddYourInfoUIController{
    fileprivate func setupAlerts(){
        alerts = AddYourInfoAlerts(viewcontroller: viewcontroller)
    }
    func showPrivacyAlert(){
        alerts.showPrivacyAlert()
    }
    func showNoProfileImageAlert(){
        alerts.showNoProfileImageAlert()
    }
    func showUploadErrorAlert(errMsg:String){
        alerts.showUploadErrorAlert(errMsg: errMsg)
    }
}

// MARK:Keyboard
extension AddYourInfoUIController{
    fileprivate func setupKeyboard(){
        keyboardHelper = KeyboardHelper(viewcontroller: viewcontroller, shiftViewWhenShow: false, keyboardWillShowClosure: { notification in
            
            self.adjustingViewHeight(notification: notification, show: true)
            
        }, keyboardWillHideClosure: { notification in
            
            self.adjustingViewHeight(notification: notification, show: false)
            
        })
    }
    
    private func adjustingViewHeight(notification: NSNotification, show: Bool) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = keyboardFrame.height
        
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            if show {
                self.viewcontroller.addInfoButtonBottomContraint.constant += changeInHeight
                self.viewcontroller.imageSlideShow.alpha = 0
                self.viewcontroller.yearLabel.alpha = 0
            }
            else {
                self.viewcontroller.addInfoButtonBottomContraint.constant = 15
                self.viewcontroller.imageSlideShow.alpha = 1
                self.viewcontroller.yearLabel.alpha = 1
            }
            self.viewcontroller.view.layoutIfNeeded()
        })
    }
}

// MARK:Loading Animation
extension AddYourInfoUIController{
    fileprivate func setupLoadingAnimation(){
        loadingAnimation = LoadingAnimation(viewcontroller: viewcontroller)
        loadingAnimation.isHidden = true
    }
    
    func playLoadingAnimation(){
        loadingAnimation.isHidden = false
        loadingAnimation.playAnimation()
    }
}
