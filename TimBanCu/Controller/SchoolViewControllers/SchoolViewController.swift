//
//  SchoolViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/7/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SchoolViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    var schoolModels = [School]()
    var searchSchoolModels = [School]()
    
    var selectedSchoolType:String!
    var selectedSchool:School!
    
    var addNewSchoolAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
    var addNewSchoolCompletedAlert = UIAlertController(title: "Trường của bạn đã được thêm!", message: "", preferredStyle: .alert)
    
    
    var noResultLabel = UILabel()
    var noResultAddNewSchoolBtn = UIButton()
    
    let searchTFUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0).withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let schoolsRef = Database.database().reference().child("schools")
    
    var searchUnderlineHeightAnchor: NSLayoutConstraint?
    
    let tieuhocQueryRef = Database.database().reference().child("schools").queryOrdered(byChild: "type").queryEqual(toValue : "th")
    let thcsQueryRef = Database.database().reference().child("schools").queryOrdered(byChild: "type").queryEqual(toValue : "thcs")
    let thptQueryRef = Database.database().reference().child("schools").queryOrdered(byChild: "type").queryEqual(toValue : "thpt")
    let daihocQueryRef = Database.database().reference().child("schools").queryOrdered(byChild: "type").queryEqual(toValue : "dh")

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        setupAlerts()
        customizeSearchTF()
        
        tableview.isHidden = true
        
        setupNoResultLabelAndButton(topViewY: searchTF.bounds.origin.y, topViewHeight: searchTF.frame.height)
    }
    
    @objc func addNewSchoolBtnPressed(_ sender: UIButton?) {
        if(selectedSchoolType == "th"){
            addNewSchoolAlert.title = "Thêm Trường Tiểu Học Mới"
        }
        else if(selectedSchoolType == "thcs"){
            addNewSchoolAlert.title = "Thêm Trường Trung Học Cơ Sở Mới"
        }
        else if(selectedSchoolType == "thpt"){
            addNewSchoolAlert.title = "Thêm Trường Trung Học Phổ Thông Mới"
        }
        else if(selectedSchoolType == "dh"){
            addNewSchoolAlert.title = "Thêm Trường Đại Học Mới"
        }
        
        self.present(addNewSchoolAlert, animated: true, completion: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func fetchData(){
        schoolModels.removeAll()
        searchSchoolModels.removeAll()
        
        if(selectedSchoolType == "th"){
            tieuhocQuery {
                DispatchQueue.main.async {
                    self.searchSchoolModels = self.schoolModels
                    self.tableview.reloadData()
                    self.updateTableviewVisibilityBasedOnSearchResult()
                }
            }
        }
        else if(selectedSchoolType == "thcs"){
            thcsQuery {
                DispatchQueue.main.async {
                    self.searchSchoolModels = self.schoolModels
                    self.tableview.reloadData()
                    self.updateTableviewVisibilityBasedOnSearchResult()
                }
            }
        }
        else if(selectedSchoolType == "thpt"){
            thptQuery {
                DispatchQueue.main.async {
                    self.searchSchoolModels = self.schoolModels
                    self.tableview.reloadData()
                    self.updateTableviewVisibilityBasedOnSearchResult()
                }
            }
        }
        else{
            daihocQuery {
                DispatchQueue.main.async {
                    self.searchSchoolModels = self.schoolModels
                    self.tableview.reloadData()
                    self.updateTableviewVisibilityBasedOnSearchResult()
                }
            }
        }
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        searchSchoolModels.removeAll()
        
        if(textField.text?.isEmpty)!{
            searchSchoolModels = schoolModels
            return
        }
        
        for school in schoolModels{
            if school.name.lowercased().range(of:textField.text!.lowercased()) != nil {
                searchSchoolModels.append(school)
            }
        }
        
        updateTableviewVisibilityBasedOnSearchResult()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchSchoolModels = schoolModels
        updateTableviewVisibilityBasedOnSearchResult()
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassViewController{
            if(selectedSchoolType == "th"){
                destination.classes = ["Lớp 1", "Lớp 2", "Lớp 3", "Lớp 4", "Lớp 5"]
            }
            else if(selectedSchoolType == "thcs"){
                destination.classes = ["Lớp 6", "Lớp 7", "Lớp 8", "Lớp 9"]
            }
            else if(selectedSchoolType == "thpt"){
                destination.classes = ["Lớp 10", "Lớp 11", "Lớp 12"]
            }
            destination.selectedSchool = selectedSchool
        }
    }
    

}
