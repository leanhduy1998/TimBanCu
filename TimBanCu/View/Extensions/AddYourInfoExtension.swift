//
//  AddYourInfoExtension.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/25/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import DropDown
import UIKit

extension AddYourInfoViewController{
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
    
    override func viewWillLayoutSubviews() {
        phonePrivacyDropDown.anchorView = phonePrivacyDropDownBtn
        emailPrivacyDropDown.anchorView = emailPrivacyDropDownBtn
    }
    
    func reloadYearLabel(page:Int){
        if(yearOfUserImage[userImages[page]] == nil){
            yearLabel.text = "Năm ?"
        }
        else{
            yearLabel.text = "\(yearOfUserImage[userImages[page]]!)"
        }
        view.layoutIfNeeded()
    }
}
