//
//  SchoolViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/7/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class SchoolViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    var schoolViewModels = [SchoolViewModel]()
    var searchSchoolVMs = [SchoolViewModel]()
    
    var selectedQueryType:String!
    var selectedSchoolVM:SchoolViewModel!
    
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
    
    var searchUnderlineHeightAnchor: NSLayoutConstraint?

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
        if(selectedQueryType == "th"){
            addNewSchoolAlert.title = "Thêm Trường Tiểu Học Mới"
        }
        else if(selectedQueryType == "thcs"){
            addNewSchoolAlert.title = "Thêm Trường Trung Học Cơ Sở Mới"
        }
        else if(selectedQueryType == "thpt"){
            addNewSchoolAlert.title = "Thêm Trường Trung Học Phổ Thông Mới"
        }
        else if(selectedQueryType == "dh"){
            addNewSchoolAlert.title = "Thêm Trường Đại Học Mới"
        }
        
        //self.present(addNewSchoolAlert, animated: true, completion: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTableviewVisibilityBasedOnSearchResult()
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        searchSchoolVMs.removeAll()
        
        if(textField.text?.isEmpty)!{
            searchSchoolVMs = schoolViewModels
            return
        }
        
        for school in schoolViewModels{
            if school.name.lowercased().range(of:textField.text!.lowercased()) != nil {
                searchSchoolVMs.append(school)
            }
        }
        
        updateTableviewVisibilityBasedOnSearchResult()
    }
    
    func fetchData(){
        self.searchSchoolVMs = self.schoolViewModels
        self.tableview.reloadData()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchSchoolVMs = schoolViewModels
        updateTableviewVisibilityBasedOnSearchResult()
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassViewController{
            if(selectedSchoolVM.type == "th"){
                destination.classes = ["Lớp 1", "Lớp 2", "Lớp 3", "Lớp 4", "Lớp 5"]
            }
            else if(selectedSchoolVM.type == "thcs"){
                destination.classes = ["Lớp 6", "Lớp 7", "Lớp 8", "Lớp 9"]
            }
            else if(selectedSchoolVM.type == "thpt"){
                destination.classes = ["Lớp 10", "Lớp 11", "Lớp 12"]
            }
            destination.selectedSchoolVM = selectedSchoolVM
        }
    }
    

}
