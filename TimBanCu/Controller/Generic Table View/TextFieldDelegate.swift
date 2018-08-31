//
//  TextFieldDelegate.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/31/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegateSetter:NSObject,UITextFieldDelegate{
    
    var didChange: (String) -> () = { _ in }
    private var viewcontroller:UIViewController!
    
    init(viewcontroller:UIViewController, textField:UITextField, didChange:@escaping ((String) -> ())){
        
        super.init()
        
        self.didChange = didChange
        self.viewcontroller = viewcontroller
        
        textField.delegate = self
        textField.addTarget(viewcontroller, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        didChange(textField.text!)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        didChange("")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewcontroller.view.endEditing(true)
        return true
    }
}
