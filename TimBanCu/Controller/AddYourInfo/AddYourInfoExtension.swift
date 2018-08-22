//
//  AddYourInfoExtension.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/25/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import DropDown
import UIKit

extension AddYourInfoViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }

    func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func adjustingViewHeight(notification: NSNotification, show: Bool) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = keyboardFrame.height
        
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            if show && !self.keyboardIsShowing {
                self.addInfoButtonBottomContraint.constant += changeInHeight
                self.imageSlideShow.alpha = 0
                self.yearLabel.alpha = 0
                self.keyboardIsShowing = true
            } else if !show {
                self.addInfoButtonBottomContraint.constant = 15
                self.imageSlideShow.alpha = 1
                self.yearLabel.alpha = 1
                self.keyboardIsShowing = false
            }
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        adjustingViewHeight(notification: notification, show: true)
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        adjustingViewHeight(notification: notification, show: false)
    }
    
    func setupPrivacyDropDowns(){
        phonePrivacyDropDown.dataSource = ["Công Khai", "Chỉ Riêng Tôi"]
        emailPrivacyDropDown.dataSource = ["Công Khai", "Chỉ Riêng Tôi"]
        
        phonePrivacyDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.phonePrivacyDropDownBtn.setTitle(item, for: .normal)
        }
        emailPrivacyDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.emailPrivacyDropDownBtn.setTitle(item, for: .normal)
        }
    }
    
    override func viewWillLayoutSubviews() {
        phonePrivacyDropDown.anchorView = phonePrivacyDropDownBtn
        emailPrivacyDropDown.anchorView = emailPrivacyDropDownBtn
    }
    
    func reloadYearLabel(page:Int){
        if(yearOfUserImage[userImages[page]] == nil){
            yearLabel.text = "Năm ?"
        }
        else{
            yearLabel.text = "\(yearOfUserImage[userImages[page]]!)"
        }
        view.layoutIfNeeded()
    }
}
