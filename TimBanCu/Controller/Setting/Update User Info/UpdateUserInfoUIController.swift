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
    
    private let viewModel = UpdateUserInfoViewModel(student: CurrentUser.student)
    
    init(viewcontroller:UpdateUserInfoViewController){
        self.viewcontroller = viewcontroller
        self.fullNameTF = viewcontroller.fullNameTF
        self.birthYearTF = viewcontroller.birthYearTF
        self.phoneNumberTF = viewcontroller.phoneNumberTF
        self.emailTF = viewcontroller.emailTF
        self.yearLabel = viewcontroller.yearLabel
        
        setup()
    }
    
    private func setup(){
        fullNameTF.text = viewModel.fullname
        birthYearTF.text = viewModel.birthYear
        phoneNumberTF.text = viewModel.phoneNumber
        emailTF.text = viewModel.email
        yearLabel.text = viewModel.birthYear
    }
    
    
}
