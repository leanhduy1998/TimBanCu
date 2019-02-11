//
//  ViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 5/13/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

import FacebookLogin
import FirebaseDatabase
import Hero

class SelectSchoolTypeViewController: UIViewController {
    
    @IBOutlet weak var tieuHocButton: UIButton!
    
    @IBOutlet weak var thptButton: UIButton!
    
    @IBOutlet weak var thcsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        customButtonTitleSize(button: thcsButton)
        customButtonTitleSize(button: thptButton)
        
        addNavigationBarShadow()
        tabBarController?.tabBar.isHidden = false
    }
    
    private func presentNextViewController(educationLevel:EducationLevel) {
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = .fade
        
        let controller = RootFactory.getSchoolViewController(educationLevel: educationLevel)
        navigationController?.add(controller)
    }
    
    private func customButtonTitleSize(button: UIButton) {
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
    }
    
    @IBAction func tieuHocBtnPressed(_ sender: Any) {
        presentNextViewController(educationLevel: .Elementary)
    }
    
    @IBAction func trunghoccosoBtnPressed(_ sender: Any) {
        presentNextViewController(educationLevel: .MiddleSchool)
    }
    
    @IBAction func trunghocphothongBtnPressed(_ sender: Any) {
        presentNextViewController(educationLevel: .HighSchool)
    }
    
    @IBAction func daihocBtnPressed(_ sender: Any) {
        presentNextViewController(educationLevel: .University)
    }
}

