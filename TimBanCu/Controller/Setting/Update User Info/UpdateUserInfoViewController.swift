//
//  ChangeYourInfoViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/1/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class UpdateUserInfoViewController: UIViewController {
    
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var birthYearTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var phonePrivacyDropDownBtn: UIButton!
    @IBOutlet weak var emailPrivacyDropDownBtn: UIButton!
    @IBOutlet weak var imageSlideShow: Slideshow!
    @IBOutlet weak var updateInfoBtn: UIButton!
    
    @IBOutlet weak var updateInfoButtonBottomContraint: NSLayoutConstraint!
    
    private var uiController:UpdateUserInfoUIController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiController = UpdateUserInfoUIController(viewcontroller: self)
        
    }
    
    
}
