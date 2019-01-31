//
//  ChangeYourInfoViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/1/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class UpdateUserInfoViewController: AddYourInfoViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = UpdateUserInfoViewModel(student: CurrentUser.student)
        
        fullNameTF.text = viewModel.fullname
        birthYearTF.text = viewModel.birthYear
        phoneTF.text = viewModel.phoneNumber
        emailTF.text = viewModel.email
        yearLabel.text = viewModel.birthYear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CurrentUser.student.getImages { (uistate) in
            switch(uistate){
            case .Success():
                DispatchQueue.main.async {
                    self.userImages = CurrentUser.student.images
                    self.uiController.reloadSlideShow()
                }
                break
            default:
                break
            }
        }
    }
    
    
}
