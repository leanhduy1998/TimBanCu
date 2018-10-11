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
        print(CurrentUser.getStudent().images.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
