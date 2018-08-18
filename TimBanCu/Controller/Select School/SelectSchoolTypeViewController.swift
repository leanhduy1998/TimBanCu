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
    var myStrings = [String]()
    var selectedSchoolType:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarShadow()
    }

    func presentNextViewController() {
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = .fade
        performSegue(withIdentifier: "SelectQueryToSchoolSegue", sender: self)
    }
    
    @IBAction func tieuHocBtnPressed(_ sender: Any) {
        selectedSchoolType = "th"
        presentNextViewController()
    }
    
    @IBAction func trunghoccosoBtnPressed(_ sender: Any) {
        selectedSchoolType = "thcs"
        presentNextViewController()
    }
    
    @IBAction func trunghocphothongBtnPressed(_ sender: Any) {
        selectedSchoolType = "thpt"
        presentNextViewController()
    }
    
    
    @IBAction func daihocBtnPressed(_ sender: Any) {
        selectedSchoolType = "dh"
        presentNextViewController()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SchoolViewController{
            destination.selectedSchoolType = selectedSchoolType
            destination.view.hero.id = selectedSchoolType
        }
        
    }


}

