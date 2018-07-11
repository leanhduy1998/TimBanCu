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
      //  scanExpression.filterExpression = "#type = :type"
       // scanExpression.expressionAttributeNames = ["#type": "type"]
       // scanExpression.expressionAttributeValues = [":type": selectedScanStr]
        
        dynamoDBObjectMapper.scan(Schools.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                for item in paginatedOutput.items {
                    let schools = item as? Schools
                    
                    for schoolStr in (schools?._schools)!{
                        let array = schoolStr.components(separatedBy: "&&&")
                        
                        let schoolVM = SchoolViewModel(name: array[0], address: array[1], type: array[2])
                        self.schoolViewModels.append(schoolVM)
                    }
                }
                
                DispatchQueue.main.async {
                    self.searchSchoolVMs = self.schoolViewModels
                    self.tableview.reloadData()
                    self.updateData(count: 0)
                    
                    
                }
            }
            return nil
        })
    }
    
    func updateData(count:Int){
        
         AWSAuthHelper.sharedInstance.getCurrentUID(completionHandler: { (uid) in
            
            self.dynamoDBObjectMapper.load(Schools.self, hashKey: uid, rangeKey:nil).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
                
                
                
                var schools = [String]()
                var temp = Schools()
                
                if let error = task.error as? NSError {
                    print("The request failed. Error: \(error)")
                    return nil
                }
                
                if let result = task.result as? Schools {
                    schools = result._schools!
                }
                    
                for school in self.schoolViewModels{
                    var string = school.name
                    string?.append("&&&")
                    string?.append(school.address)
                    string?.append("&&&")
                    string?.append(school.type)
                    
                    schools.append(string!)
                }
                temp?._schools = schools
                
                
                temp?._userId = uid
                
                self.dynamoDBObjectMapper.save(temp!).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
                    if let error = task.error as? NSError {
                        print("The request failed. Error: \(error)")
                    } else {
                        print("success")
                    }
                    return nil
                })
     
                
                
                return nil
            })
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
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
