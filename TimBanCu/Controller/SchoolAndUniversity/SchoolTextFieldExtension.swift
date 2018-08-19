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
}
