//
//  ActionAlert.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/18/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

// should not subclass uialertcontroller because of https://developer.apple.com/documentation/uikit/uialertcontroller#//apple_ref/doc/uid/TP40014538-CH1-SW2
class AskForInputAlert{
    
    private var alert:UIAlertController!
    private var textField:UITextField!
    
    init(title:String,message:String, textFieldPlaceHolder:String){
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { [weak alert] (_) in
            alert?.dismiss(animated: true, completion: nil)
        }))
        
        alert.addTextField { (textField) in
            textField.placeholder = textFieldPlaceHolder
            self.textField = textField
        }
    }
    
    func setTextFieldKeyboardType(type:UIKeyboardType){
        textField.keyboardType = type
    }
    
    func show(viewcontroller:UIViewController){
        viewcontroller.present(alert, animated: true, completion: nil)
    }
    
    func getTextFieldInput()->String{
        return textField.text!
    }
    
    func addAction(actionTitle:String, handler: @escaping ((UIAlertAction) -> Void)){
        let action = UIAlertAction(title: actionTitle, style: .default, handler: handler)
        
        alert.addAction(action)
    }
}
