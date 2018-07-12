//
//  SchoolViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/7/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import AWSDynamoDB

class SchoolViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var noResultView: UIView!
    
    let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
    var schoolViewModels = [SchoolViewModel]()
    var searchSchoolVMs = [SchoolViewModel]()
    
    var selectedScanStr:String!
    var selectedSchoolVM:SchoolViewModel!
    
    var addNewSchoolAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
    var addNewSchoolCompletedAlert = UIAlertController(title: "Trường của bạn đã được thêm!", message: "", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        setupAlerts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noResultView.isHidden = true
        tableview.isHidden = false
    }
    
    func fetchData(){
        self.searchSchoolVMs = self.schoolViewModels
        self.tableview.reloadData()
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
        
        setTableviewVisibilityBasedOnSearchResult()
    }
    
    func setTableviewVisibilityBasedOnSearchResult(){
        if(searchSchoolVMs.count == 0){
            noResultView.isHidden = false
            tableview.isHidden = true
        }
        else{
            noResultView.isHidden = true
            tableview.isHidden = false
            tableview.reloadData()
        }
    }
    
    
    @IBAction func clearBtnPressed(_ sender: Any) {
        searchTF.text = ""
        searchSchoolVMs = schoolViewModels
        tableview.reloadData()
    }
    
    @IBAction func addNewSchoolBtnPressed(_ sender: Any) {
        if(selectedScanStr == "elementary"){
            addNewSchoolAlert.title = "Thêm Trường Tiểu Học Mới"
        }
        else if(selectedScanStr == "secondary"){
            addNewSchoolAlert.title = "Thêm Trường Trung Học Cơ Sở Mới"
        }
        else if(selectedScanStr == "highschool"){
            addNewSchoolAlert.title = "Thêm Trường Trung Học Phổ Thông Mới"
        }
        else if(selectedScanStr == "university"){
            addNewSchoolAlert.title = "Thêm Trường Đại Học Mới"
        }
        
        self.present(addNewSchoolAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassViewController{
            if(selectedSchoolVM.type == "elementary"){
                destination.classes = ["Lớp 1", "Lớp 2", "Lớp 3", "Lớp 4", "Lớp 5"]
            }
            else if(selectedSchoolVM.type == "secondary"){
                destination.classes = ["Lớp 6", "Lớp 7", "Lớp 8", "Lớp 9"]
            }
            else if(selectedSchoolVM.type == "highschool"){
                destination.classes = ["Lớp 10", "Lớp 11", "Lớp 12"]
            }
            destination.selectedSchoolVM = selectedSchoolVM
        }
    }
    

}
