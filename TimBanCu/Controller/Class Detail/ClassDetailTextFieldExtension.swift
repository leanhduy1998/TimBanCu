//
//  ClassDetailTextFieldExtension.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/18/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension ClassDetailViewController{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.searchTFUnderline.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
            self.searchUnderlineHeightAnchor?.constant = 2.5
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            if textField.text == "" {
                self.searchTFUnderline.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 0.5)
                self.searchUnderlineHeightAnchor?.constant = 1.5
            }
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
