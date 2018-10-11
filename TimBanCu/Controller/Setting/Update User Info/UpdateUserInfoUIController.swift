//
//  UpdateUserInfoUIController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/9/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class UpdateUserInfoUIController{
    private weak var viewcontroller:UpdateUserInfoViewController!
    
    private var fullNameTF: UITextField!
    private var birthYearTF: UITextField!
    private var phoneNumberTF: UITextField!
    private var emailTF: UITextField!
    private var yearLabel: UILabel!
    
    init(viewcontroller:UpdateUserInfoViewController){
        self.viewcontroller = viewcontroller
        self.fullNameTF = viewcontroller.fullNameTF
        
        setup()
    }
    
    private func setup(){
        fullNameTF.text = CurrentUser.getFullname()
        birthYearTF.text = CurrentUser.getStudent().birthYear
        phoneNumberTF.text = CurrentUser.getStudent().phoneNumber
        emailTF.text = CurrentUser.getStudent().email
        yearLabel.text = CurrentUser.getStudent().birthYear
        
        
    }
    
    
}
