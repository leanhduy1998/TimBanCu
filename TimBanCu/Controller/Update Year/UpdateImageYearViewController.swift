//
//  UpdateImageYearViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/13/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class UpdateImageYearViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var yearTF: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    
    var selectedImage:Image!
    
    private var allowedLowerBoundYear:Int!
    private var allowedUpperBoundYear:Int!
    
    private var uiController:UpdateImageYearUIController!
    private var keyboardHelper:KeyboardHelper!
    
    private var tabBarHeight : CGFloat = 0.0
    private var keyboardIsShowing = false
    
    //TODO: write test case to make sure all items needed are passed from segue
    override func viewDidLoad() {
        super.viewDidLoad()
        imageview.image = selectedImage.image
        tabBarHeight = (tabBarController?.tabBar.frame.size.height)!
        
        if(selectedImage.year != nil){
            yearTF.placeholder = selectedImage.year
        }
        
        yearTF.delegate = self
        yearTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        uiController = UpdateImageYearUIController(viewcontroller: self)
        
        setupYearBounds()
        setupKeyboard()
    }
    
    private func setupYearBounds(){
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        allowedLowerBoundYear = year - 80
        allowedUpperBoundYear = year
    }
    
    @IBAction func updateBtnPressed(_ sender: Any) {
        if((Int(yearTF.text!)!) < allowedLowerBoundYear){
            uiController.showYearOutOfLowerBoundAlert()
        }
        else if((Int(yearTF.text!)!) > allowedUpperBoundYear){
            uiController.showYearIsInTheFutureAlert()
        }
        else{
            selectedImage.year = yearTF.text
            navigationController?.popViewController(animated: true)
            //performSegue(withIdentifier: "UpdateImageYearToAddYourInfoControllerSegue", sender: self)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateBtn.isEnabled = !(textField.text?.isEmpty)!
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddYourInfoViewController{
            /*for image in destination.userImages{
                if(image.imageName == selectedImage.image){
                    image = selectedImage
                    break
                }
            }*/
        }
    }
    
    private func setupKeyboard(){
        keyboardHelper = KeyboardHelper(viewcontroller: self, shiftViewWhenShow: false, keyboardWillShowClosure: { notification in
            
            self.adjustingViewHeight(notification: notification, show: true)
            
        }, keyboardWillHideClosure: { notification in
            
            self.adjustingViewHeight(notification: notification, show: false)
            
        })
    }
    
    private func adjustingViewHeight(notification: NSNotification, show: Bool) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = keyboardFrame.height
        
        
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            if show && !self.keyboardIsShowing {
                self.view.frame.origin.y = self.view.frame.origin.y - changeInHeight + self.tabBarHeight
                self.keyboardIsShowing = true
            } else if !show && self.keyboardIsShowing {
                self.view.frame.origin.y = self.view.frame.origin.y + changeInHeight - self.tabBarHeight
                self.keyboardIsShowing = false
            }
        })
    }
    

}
