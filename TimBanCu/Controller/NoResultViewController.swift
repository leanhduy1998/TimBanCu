//
//  NoResultViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/3/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import UIKit
import Lottie

class NoResultViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var animationView: LOTAnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textfield: UITextField!
    
    @IBOutlet weak var actionBtn: UIButton!

    private var handleAction:()->Void = {}
    
    private var titleStr = "Không có kết quả"
    private var textfieldPlaceholder = "Lỗi! Không thể điền thông tin"
    private var actionStr = "Lỗi! Không thể thêm thông tin"
   
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleLabel.text = titleStr
        actionBtn.setTitle(actionStr, for: .normal)
        textfield.placeholder = textfieldPlaceholder
        
        textfield.delegate = self
        
        actionBtn.setTitleColor(UIColor.darkGray, for: .disabled)
    }
    
    func inject(titleStr:String, textfieldPlaceholder: String,actionStr:String,handleAction: @escaping ()->Void){
        self.titleStr = titleStr
        self.textfieldPlaceholder = titleStr
        self.actionStr = titleStr
        
        self.handleAction = handleAction
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        enableBtnBasedOnTextfield()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        enableBtnBasedOnTextfield()
    }
    
    private func enableBtnBasedOnTextfield(){
        if textfieldIsEmpty(){
            actionBtn.isEnabled = false
        }
        else{
            actionBtn.isEnabled = true
        }
    }
    
    func getTextFieldText()->String{
        return textfield.text!
    }
    
    private func textfieldIsEmpty()->Bool{
        return textfield.text?.trimmingCharacters(in: .whitespaces) == ""
    }
    
    @IBAction func btnDidPressed(_ sender: Any) {
        handleAction()
    }
    

}
