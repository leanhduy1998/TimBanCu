//
//  SchoolDelegate.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/10/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension SchoolViewController:UITextFieldDelegate{
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateUI()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        updateUI()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
