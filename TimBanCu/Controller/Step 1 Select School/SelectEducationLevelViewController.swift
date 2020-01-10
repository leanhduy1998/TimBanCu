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

class SelectEducationLevelViewController: UIViewController {
    
    @IBOutlet weak var tieuHocButton: UIButton!
    
    @IBOutlet weak var thptButton: UIButton!
    @IBOutlet weak var thcsButton: UIButton!
    
    private var selectedEducationLevel:EducationLevel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        customButtonTitleSize(button: thcsButton)
        customButtonTitleSize(button: thptButton)
        
        addNavigationBarShadow()
        tabBarController?.tabBar.isHidden = false
    }
    
    private func presentNextViewController() {
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = .fade
        performSegue(withIdentifier: "SelectQueryToSchoolSegue", sender: self)
    }
    
    private func customButtonTitleSize(button: UIButton) {
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
    }
    
    @IBAction func tieuHocBtnPressed(_ sender: Any) {
        selectedEducationLevel = EducationLevel.Elementary
        presentNextViewController()
    }
    
    @IBAction func trunghoccosoBtnPressed(_ sender: Any) {
        selectedEducationLevel = EducationLevel.MiddleSchool
        presentNextViewController()
    }
    
    @IBAction func trunghocphothongBtnPressed(_ sender: Any) {
        selectedEducationLevel = EducationLevel.HighSchool
        presentNextViewController()
    }
    
    @IBAction func daihocBtnPressed(_ sender: Any) {
        selectedEducationLevel = EducationLevel.University
        presentNextViewController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destionation = segue.destination as? SchoolViewController{
            destionation.inject(educationLevel: selectedEducationLevel)
        }
    }
}

