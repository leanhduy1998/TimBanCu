//
//  SchoolTextFieldExtension.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/18/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension SchoolViewController{
    @objc func textFieldDidChange(_ textField: UITextField) {
        searchSchoolModels.removeAll()
        
        if(textField.text?.isEmpty)!{
            searchSchoolModels = schoolModels
            return
        }
        
        for school in schoolModels{
            if school.name.lowercased().range(of:textField.text!.lowercased()) != nil {
                searchSchoolModels.append(school)
            }
        }
        
        updateItemsVisibilityBasedOnSearchResult()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchSchoolModels = schoolModels
        updateItemsVisibilityBasedOnSearchResult()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.searchTFUnderline.backgroundColor = themeColor.withAlphaComponent(0.7)
            self.searchUnderlineHeightAnchor?.constant = 2.5
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            if textField.text == "" {
                self.searchTFUnderline.backgroundColor = themeColor.withAlphaComponent(0.4)
                self.searchUnderlineHeightAnchor?.constant = 1.5
            }
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
