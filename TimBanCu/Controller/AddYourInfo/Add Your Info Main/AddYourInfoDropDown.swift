//
//  AddYourInfoDropDown.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/19/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit
import DropDown

extension AddYourInfoViewController{
    @IBAction func phoneDropDownBtnPressed(_ sender: Any) {
        phonePrivacyDropDown.show()
    }
    
    @IBAction func emailDropDownBtnPressed(_ sender: Any) {
        emailPrivacyDropDown.show()
    }
}
