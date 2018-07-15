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
    
    var schoolViewModels = [SchoolViewModel]()
    
    let tieuhocQueryRef = Database.database().reference().child("schools").queryOrdered(byChild: "type").queryEqual(toValue : "th")
    let thcsQueryRef = Database.database().reference().child("schools").queryOrdered(byChild: "type").queryEqual(toValue : "thcs")
    let thptQueryRef = Database.database().reference().child("schools").queryOrdered(byChild: "type").queryEqual(toValue : "thpt")
    let daihocQueryRef = Database.database().reference().child("schools").queryOrdered(byChild: "type").queryEqual(toValue : "dh")
    
    var selectedTypeQuery:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarShadow()
    }
    
    @IBAction func tieuHocBtnPressed(_ sender: Any) {
        schoolViewModels.removeAll()
        
        tieuhocQueryRef.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let value = (snap as! DataSnapshot).value as? [String:Any]
                
                let name = (snap as! DataSnapshot).key
                let address = value!["address"] as? String
                let uid = value!["uid"] as? String
                
                let school = SchoolViewModel(name: name, address: address!, type: "th", uid: uid!)
                
                self.schoolViewModels.append(school)
            }
            
            DispatchQueue.main.async {
                self.selectedTypeQuery = "th"
                self.performSegue(withIdentifier: "SelectQueryToSchoolSegue", sender: self)
            }
        }
    }
    
    @IBAction func trunghoccosoBtnPressed(_ sender: Any) {
        thcsQueryRef.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let value = (snap as! DataSnapshot).value as? [String:Any]
                
                let name = (snap as! DataSnapshot).key
                let address = value!["address"] as? String
                let uid = value!["uid"] as? String
                
                let school = SchoolViewModel(name: name, address: address!, type: "thcs", uid: uid!)
                
                self.schoolViewModels.append(school)
            }
            
            DispatchQueue.main.async {
                self.selectedTypeQuery = "thcs"
                self.performSegue(withIdentifier: "SelectQueryToSchoolSegue", sender: self)
            }
        }
    }
    
    @IBAction func trunghocphothongBtnPressed(_ sender: Any) {
        thptQueryRef.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let value = (snap as! DataSnapshot).value as? [String:Any]
                
                let name = (snap as! DataSnapshot).key
                let address = value!["address"] as? String
                let uid = value!["uid"] as? String
                
                let school = SchoolViewModel(name: name, address: address!, type: "thpt", uid: uid!)
                
                self.schoolViewModels.append(school)
            }
            
            DispatchQueue.main.async {
                self.selectedTypeQuery = "thpt"
                self.performSegue(withIdentifier: "SelectQueryToSchoolSegue", sender: self)
            }
        }
    }
    
    
    @IBAction func daihocBtnPressed(_ sender: Any) {
        daihocQueryRef.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let value = (snap as! DataSnapshot).value as? [String:Any]
                
                let name = (snap as! DataSnapshot).key
                let address = value!["address"] as? String
                let uid = value!["uid"] as? String
                
                let school = SchoolViewModel(name: name, address: address!, type: "dh", uid: uid!)
                
                self.schoolViewModels.append(school)
            }
            
            DispatchQueue.main.async {
                self.selectedTypeQuery = "dh"
                self.performSegue(withIdentifier: "SelectQueryToSchoolSegue", sender: self)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SchoolViewController{
           destination.schoolViewModels = schoolViewModels
            destination.selectedQueryType = selectedTypeQuery
        }
    }


}

