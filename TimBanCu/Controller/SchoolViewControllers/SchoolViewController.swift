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
    
    
    var schoolViewModels = [SchoolViewModel]()
    var searchSchoolVMs = [SchoolViewModel]()
    
    var selectedScanStr:String!
    var selectedSchoolVM:SchoolViewModel!
    
    let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
    
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
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 20000
        scanExpression.filterExpression = "#type = :type"
        scanExpression.expressionAttributeNames = ["#type": "type"]
        scanExpression.expressionAttributeValues = [":type": selectedScanStr]
        
        dynamoDBObjectMapper.scan(School.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                for school in paginatedOutput.items {
                    let school = school as? School
                    
                    self.schoolViewModels.append(SchoolViewModel(name: (school?._school)!, address: (school?._address)!, type: (school?._type)!))
                }
                
                DispatchQueue.main.async {
                    self.searchSchoolVMs = self.schoolViewModels
                    self.tableview.reloadData()
                }
            }
            return nil
        })
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
