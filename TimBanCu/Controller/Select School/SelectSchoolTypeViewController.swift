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
    var selectedSchoolType:EducationLevel!
    
    private var uiController: SelectSchoolTypeUIController!

    override func viewDidLoad() {
        super.viewDidLoad()
        uiController = SelectSchoolTypeUIController(viewcontroller: self)
        
        uiController.customButtonTitleSize(button: thcsButton)
        uiController.customButtonTitleSize(button: thptButton)
        
        
    }
    
    @IBAction func tieuHocBtnPressed(_ sender: Any) {
        selectedSchoolType = .Elementary
        uiController.presentNextViewController()
    }
    
    @IBAction func trunghoccosoBtnPressed(_ sender: Any) {
        selectedSchoolType = .MiddleSchool
        uiController.presentNextViewController()
    }
    
    @IBAction func trunghocphothongBtnPressed(_ sender: Any) {
        selectedSchoolType = .HighSchool
        uiController.presentNextViewController()
    }
    
    @IBAction func daihocBtnPressed(_ sender: Any) {
        selectedSchoolType = .University
        uiController.presentNextViewController()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SchoolViewController{
            destination.educationLevel = selectedSchoolType
        }
    }
}

