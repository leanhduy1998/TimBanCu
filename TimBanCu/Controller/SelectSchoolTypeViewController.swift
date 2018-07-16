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

class SelectSchoolTypeViewController: UIViewController {
    
    var myStrings = [String]()
    var selectedSchoolType:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarShadow()
    }
    
    @IBAction func tieuHocBtnPressed(_ sender: Any) {
        selectedSchoolType = "th"
        performSegue(withIdentifier: "SelectQueryToSchoolSegue", sender: self)
    }
    
    @IBAction func trunghoccosoBtnPressed(_ sender: Any) {
        selectedSchoolType = "thcs"
        performSegue(withIdentifier: "SelectQueryToSchoolSegue", sender: self)
    }
    
    @IBAction func trunghocphothongBtnPressed(_ sender: Any) {
        selectedSchoolType = "thpt"
        performSegue(withIdentifier: "SelectQueryToSchoolSegue", sender: self)
    }
    
    
    @IBAction func daihocBtnPressed(_ sender: Any) {
        selectedSchoolType = "dh"
        performSegue(withIdentifier: "SelectQueryToSchoolSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SchoolViewController{
            destination.selectedSchoolType = selectedSchoolType
        }
    }


}

