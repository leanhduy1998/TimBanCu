//
//  KeyboardHelper.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/14/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class KeyboardHelper{
    private weak var viewcontroller:UIViewController!
    private var shiftViewWhenShow:Bool!
    
    private var keyboardWillShowClosure: ((NSNotification)->())?
    private var keyboardWillHideClosure: ((NSNotification)->())?
    
    private var keyboardIsShowing = false
    
    init(viewcontroller:UIViewController,shiftViewWhenShow:Bool,keyboardWillShowClosure: ((NSNotification)->())?,keyboardWillHideClosure: ((NSNotification)->())?){
        self.viewcontroller = viewcontroller
        self.shiftViewWhenShow = shiftViewWhenShow
        self.keyboardWillShowClosure = keyboardWillShowClosure
        self.keyboardWillHideClosure = keyboardWillHideClosure
        
        observeKeyboardNotifications()
        setupTouchScreenToDismissKeyboard()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func setupTouchScreenToDismissKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        viewcontroller.view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        viewcontroller.view.endEditing(true)
    }
    
    private func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardHelper.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardHelper.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShow(notification:NSNotification) {
        if(keyboardIsShowing){
           return
        }
        keyboardIsShowing = true
        
        if(shiftViewWhenShow){
            var userInfo = notification.userInfo!
            let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
            let keyboardHeight = keyboardFrame.height
            
            UIView.animate(withDuration: animationDurarion) {
                self.viewcontroller.view.frame.origin.y -= keyboardHeight
            }
        }
        if(keyboardWillShowClosure != nil){
            keyboardWillShowClosure!(notification)
        }
    }
    
    @objc private func keyboardWillHide(notification:NSNotification) {

        keyboardIsShowing = false
        
        if(shiftViewWhenShow){
            var userInfo = notification.userInfo!
            let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
            let keyboardHeight = keyboardFrame.height
            
            UIView.animate(withDuration: animationDurarion) {
                self.viewcontroller.view.frame.origin.y += keyboardHeight
            }
        }
        if(keyboardWillHideClosure != nil){
            keyboardWillHideClosure!(notification)
        }
    }
}
