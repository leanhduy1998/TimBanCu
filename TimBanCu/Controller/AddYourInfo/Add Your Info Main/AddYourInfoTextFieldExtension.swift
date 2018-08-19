//
//  AddYourInfoTextFieldExtension.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/19/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension AddYourInfoViewController{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -150, width: self.view.frame.width, height: self.view.frame.height)
            
            
        }, completion: nil)
    }
    
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)! + 20, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
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
}
