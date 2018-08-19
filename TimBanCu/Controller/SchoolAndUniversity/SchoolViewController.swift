//
//  SchoolViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/7/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Lottie
import Hero

class SchoolViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    var schoolModels = [School]()
    var searchSchoolModels = [School]()
    
    var selectedSchoolType:String!
    var selectedSchool:School!
    
    var noResultLabel = NoResultLabel(type: Type.School)
    var noResultAddNewSchoolBtn = NoResultButton(type: Type.School)
    
    let animatedEmoticon: LOTAnimationView = {
        let animation = LOTAnimationView(name: "empty_list")
        animation.contentMode = .scaleAspectFill
        animation.loopAnimation = true
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
    var finishedLoadingInitialTableCells = false
    
    //alert
    var addNewSchoolAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
    var addNewSchoolCompletedAlert = UIAlertController(title: "Trường của bạn đã được thêm!", message: "", preferredStyle: .alert)
    let schoolAlreadyExistAlert = UIAlertController(title: "Trường của bạn đã có trong danh sách!", message: "Vui Lòng Chọn Trường Trong Danh Sách Chúng Tôi Hoặc Thêm Trường Mới", preferredStyle: .alert)
    
    
    //database
    let tieuhocQueryRef = Database.database().reference().child("schools").queryOrdered(byChild: "type").queryEqual(toValue : "th")
    let thcsQueryRef = Database.database().reference().child("schools").queryOrdered(byChild: "type").queryEqual(toValue : "thcs")
    let thptQueryRef = Database.database().reference().child("schools").queryOrdered(byChild: "type").queryEqual(toValue : "thpt")
    let daihocQueryRef = Database.database().reference().child("schools").queryOrdered(byChild: "type").queryEqual(toValue : "dh")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setupAlerts()
        setUpAnimatedEmoticon()
        setupNoResultLabelAndButton()
        
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
        
        if (self.isMovingFromParentViewController) {
            navigationController?.hero.isEnabled = true
            navigationController?.hero.navigationAnimationType = .fade
        } 
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
        noResultLabel.isHidden = true
        noResultAddNewSchoolBtn.isHidden = true
        animatedEmoticon.isHidden = true
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
    
    func updateTableviewVisibilityBasedOnSearchResult(){
        if(searchSchoolModels.count == 0){
            noResultLabel.isHidden = false
            noResultAddNewSchoolBtn.isHidden = false
            tableview.isHidden = true

            animatedEmoticon.isHidden = false
            animatedEmoticon.play()
        }
        else{
            noResultLabel.isHidden = true
            noResultAddNewSchoolBtn.isHidden = true
            tableview.isHidden = false
            tableview.reloadData()

            animatedEmoticon.isHidden = true
            animatedEmoticon.stop()
        }
        
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
            destination.school = selectedSchool
        }
        if let destination = segue.destination as? MajorViewController{
            destination.school = selectedSchool
        }
    }
    

}
