//
//  ClassDetailViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/9/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ClassNameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    var selectedSchool:School!
    var selectedClassNumber: String!
    var selectedClassName:ClassDetail!
    
    //database
    var schoolAllClassesDetailsQuery:DatabaseQuery!
    var classesDetailRef = Database.database().reference().child("classes")
    
    //no result
    var noResultLabel = NoResultLabel(text: "Chưa có lớp. Bạn có muốn thêm lớp?               Ví dụ: 10A11")
    var noResultAddNewClassBtn = NoResultButton(title: "Thêm Lớp Mới")
    
    //tableview
    var classNames = [ClassDetail]()
    
    //alert
    var addNewClassAlert = UIAlertController(title: "Thêm Lớp Mới", message: "", preferredStyle: .alert)
    var addNewClassCompletedAlert = UIAlertController(title: "Lớp của bạn đã được thêm!", message: "", preferredStyle: .alert)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNoResultLabelAndButton()
        setupAlerts()
    }
    
    override func viewDidLayoutSubviews() {
        setupNoResultLabelAndButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func fetchData(){
        classNames.removeAll()
        
        schoolAllClassesDetailsQuery = classesDetailRef.queryOrdered(byChild: "schoolName").queryEqual(toValue : selectedSchool.name)
        schoolAllClassesDetailsQuery.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let value = (snap as! DataSnapshot).value as? [String:Any]
                
                let classNumber = value!["classNumber"] as! String
                
                if(classNumber == self.selectedClassNumber){
                    let uid = value!["uid"] as! String
                    let schoolName = value!["schoolName"] as! String
                    let className = value!["className"] as! String
                    
                    let classDetailModel = ClassDetail(classNumber: classNumber, uid: uid, schoolName: schoolName, className: className)
                    
                    self.classNames.append(classDetailModel)
                }
            }
            
            DispatchQueue.main.async {
                self.tableview.reloadData()
                self.updateTableviewVisibilityBasedOnSearchResult()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassNameTableViewCell") as? ClassNameTableViewCell
        cell?.classDetailViewModel = ClassNameViewModel(classDetail: classNames[indexPath.row])
   
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedClassName = classNames[indexPath.row]
        performSegue(withIdentifier: "ClassNameToClassDetailSegue", sender: self)
    }
    
    @objc func addNewClassDetailBtnPressed(_ sender: UIButton?) {
        self.present(addNewClassAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassDetailViewController{
            destination.selectedClassDetail = selectedClassName
        }
    }
    

}
